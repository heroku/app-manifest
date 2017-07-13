module AppManifest
  # Serialization logic for AppManifest models
  module Serializer
    def self.serialize(value)
      case value
      when Array
        value.map { |v| serialize(v) }
      when Hash
        value.each_with_object({}) do |(k, v), h|
          h[k] = serialize(v)
        end
      when Integer, Float, String, Symbol, TrueClass, FalseClass, NilClass
        value
      else
        if value.respond_to?(:attributes)
          value.attributes.each_with_object({}) do |(key, val), hash|
            case val
            when Array, Hash
              hash[key] = serialize(val) unless val.empty?
            else
              hash[key] = serialize(val) unless val.nil?
            end
          end
        else
          val.to_s
        end
      end
    end

    def to_hash
      Serializer.serialize(self)
    end
  end
end
