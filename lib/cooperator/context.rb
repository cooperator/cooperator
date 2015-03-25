module Cooperator
  class Context
    def initialize(attributes = {})
      @_attributes = {_failure: false}

      attributes.each do |k, v|
        self[k] = v
      end
    end

    def errors
      @_errors ||= Hash.new { |h, k| h[k] = [] }
    end

    def success!
      self[:_failure] = false
    end

    def failure!(messages = {})
      messages.each do |key, message|
        errors[key].push message
      end

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

    def []=(key, value)
      @_attributes[key] = value
    end

    def [](key)
      @_attributes[key]
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
      name = String method
      name.gsub!(/=/, '') if name.include? '='

      @_attributes.include?(:"#{name}") || super
    end
  end
end
