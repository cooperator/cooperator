require 'cooperator/version'
require 'cooperator/context'

module Cooperator
  module ClassMethods
    def requirements
      @_requirements ||= []
    end

    def needs(*properties)
      properties.each do |property|
        define_method property do
          context.send property
        end

        requirements << property
      end
    end

    def wants(*properties)
      properties.each do |property|
        define_method property do
          if context.include? property
            context.send property
          else
            nil
          end
        end
      end
    end

    def perform(context = {})
      action = new context

      catch :_finish do
        action.perform
      end

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
    actions.each do |action|
      action.perform context

      break if context.failure?
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
