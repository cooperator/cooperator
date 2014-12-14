require 'cooperator/version'
require 'cooperator/context'

module Cooperator
  module ClassMethods
    def expected
      @_expected ||= []
    end

    def accepted
      @_accepted ||= []
    end

    def committed
      @_committed ||= []
    end

    def expects(*properties)
      properties.each do |property|
        define_method property do
          context.send property
        end

        expected << property
      end
    end

    def accepts(*properties)
      properties.each do |property|
        define_method property do
          if context.include? property
            context.send property
          else
            nil
          end
        end

        accepted << property
      end
    end

    def commits(*properties)
      properties.each do |property|
        committed << property
      end
    end

    def perform(context = {})
      expected.each do |property|
        raise Exception, "missing expected property: #{property}" unless context.include? property
      end

      action = new context

      catch :_finish do
        action.perform
      end

      committed.each do |property|
        raise Exception, "missing committed property: #{property}" unless action.context.include? property
      end

      action.context
    end

    def rollback(context = {})
      action = new context

      action.rollback if action.respond_to? :rollback

      action.context
    end
  end

  def context
    @_context
  end

  def initialize(context = Context.new)
    @_context = if context.is_a? Context
                  context
                else
                  Context.new context
                end
  end

  def cooperate(*actions)
    done = []

    actions.each do |action|
      action.perform context

      break if context.failure?

      done << action
    end

    if context.failure?
      done.reverse.each do |action|
        action.rollback context
      end
    end
  end

  def commit(properties = {})
    properties.each do |key, value|
      context.send :"#{key}=", value
    end
  end

  def self.prepended(base)
    base.extend ClassMethods
  end

  private

  def success!
    context.success!
    throw :_finish
  end

  def success?
    context.success?
  end

  def failure!(messages = {})
    context.failure! messages
    throw :_finish
  end

  def failure?
    context.failure?
  end

  def include?(property)
    context.include?(property)
  end
end
