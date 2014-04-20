module Cooperator
  class Context
    def initialize(attributes = {})
      @_attributes = {_failure: false}

      attributes.each do |k, v|
        send :"#{k}=", v
      end
    end

    def errors
      @_errors ||= []
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

    def include?(key)
      @_attributes.include? key
    end

    def method_missing(method, *args, &block)
      return @_attributes.fetch method if @_attributes.include? method

      name = String method

      if name.include? '='
        name.gsub!(/=/, '')

        @_attributes[:"#{name}"] = args.shift
      else
        super
      end
    end

    def respond_to_missing?(method, private = false)
      @_attributes.include?(method) || super
    end
  end
end
