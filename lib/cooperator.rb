require "cooperator/version"

require 'hashie'

module Cooperator
  class Context < Hashie::Mash
  end

  module ClassMethods
    def perform(context = nil)
      action = new context
      action.perform
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
end
