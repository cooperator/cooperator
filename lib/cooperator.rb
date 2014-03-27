require 'cooperator/version'
require 'cooperator/context'

module Cooperator
  module ClassMethods
    def perform(context = {})
      action = new context

      catch :finish do
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
    throw :finish
  end

  def success?
    context.success?
  end

  def failure!
    context.failure!
    throw :finish
  end
end
