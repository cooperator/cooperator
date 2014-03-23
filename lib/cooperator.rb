require "cooperator/version"

module Cooperator
  class Context
    def initialize(attributes = {})
      @_attributes = {}

      attributes.each do |k, v|
        send :"#{k}=", v
      end
    end

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

    def method_missing(method, *args, &block)
      method = String method

      if method.include? '='
        method.gsub!(/=/, '')

        @_attributes[:"#{method}"] = args.shift
      else
        @_attributes[:"#{method}"]
      end
    end
  end

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

  def self.prepended(base)
    base.extend ClassMethods
  end

  private

  def success!
    context.success!
    throw :finish
  end

  def failure!
    context.failure!
    throw :finish
  end
end
