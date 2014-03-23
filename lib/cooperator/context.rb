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
end
