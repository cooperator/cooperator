require "cooperator/version"

require 'hashie'

module Cooperator
  module ClassMethods
    def perform(context = nil)
      new(context).perform
    end
  end

  def context
    @_context
  end

  def initialize(context = Hashie::Mash.new)
    @_context = context
  end

  def self.prepended(base)
    base.extend ClassMethods
  end
end
