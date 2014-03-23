require "cooperator/version"

require 'hashie'

module Cooperator
  class Context < Hashie::Mash
    def success!
      self._failure = false
    end

    def failure!
      self._failure = true
    end

    def success?
      not failure?
    end

    def failure?
      _failure
    end
  end

  module ClassMethods
    def perform(context = nil)
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

  def self.prepended(base)
    base.extend ClassMethods
  end

  private

  def success!
    context.success!
    throw :finish
  end

  def failure!
    throw :finish
  end
end
