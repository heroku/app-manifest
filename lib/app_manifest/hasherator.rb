module AppManifest
  module Hasherator
    def to_hash
      attributes.each_with_object({}) do |(key, value), hash|
        case value
        when Array
          hash[key] = value.map { |v| hasherate(v) } unless value.empty?
        when Hash
          unless value.empty?
            hash[key] = value.each_with_object({}) do |(k, v), h|
              h[k] = hasherate(v)
            end
          end
        else
          hash[key] = hasherate(value) unless value.nil?
        end
      end
    end

    def hasherate(val)
      case val
      when Integer, Float, String, Symbol, TrueClass, FalseClass, NilClass
        val
      else
        if val.respond_to?(:attributes) && val.respond_to?(:to_hash)
          val.to_hash
        else
          val.to_s
        end
      end
    end
  end
end
