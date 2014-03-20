require "cooperator/version"

require 'hashie'

module Cooperator
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

  def initialize(context = Hashie::Mash.new)
    @_context = if context.is_a? Hashie::Mash
                  context
                else
                  Hashie::Mash.new context
                end
  end

  def self.prepended(base)
    base.extend ClassMethods
  end
end
