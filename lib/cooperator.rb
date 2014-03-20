require "cooperator/version"

module Cooperator
  module ClassMethods
    def perform
      new.perform
    end
  end

  def self.prepended(base)
    base.extend ClassMethods
  end
end
