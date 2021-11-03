module AppManifest
  class InvalidManifest < StandardError; end

  # app.json manifest validation
  module ManifestValidator

    def self.validate!(manifest)
      do_validate(manifest)
    end

    private

    def self.do_validate(hash, env_name: nil)
      hash.each do |key, value|
        case key.to_s
        when 'addons'
          validate_array(key, value, required: false, env_name: env_name) do |v, index: nil, env_name: nil|
            validate_addon_value(key, v, index: index, env_name: env_name)
          end
        when 'buildpacks'
          validate_array(key, value, required: false, env_name: env_name)
        when 'env'
          validate_env(key, value, env_name: env_name)
        when 'name'
          validate_string(key, value, required: false, max_length: 30, env_name: env_name)
        when 'description', 'image', 'logo', 'repository', 'stack', 'success_url', 'website'
          validate_string(key, value, required: false, env_name: env_name)
        when 'environments'
          validate_environments(key, value) if env_name.nil?
        when 'keywords'
          validate_array(key, value, required: false, env_name: env_name) do |v, index: nil, env_name: nil|
            validate_string(key, v, required: false, index: index, env_name: env_name)
          end
        when 'scripts', 'formation'
        else
          raise InvalidManifest, "Unknown key: #{build_key_name(key, env_name: env_name)}"
        end
      end
    end

    def self.build_key_name(key, index: nil, env_name: nil)
      name = []
      name << env_name if env_name
      name << '[' if env_name
      name << key
      name << ']' if env_name
      name << "[#{index}]" if index
      name.join
    end

    def self.for_key(key, index: nil, env_name: nil)
      "for key: #{build_key_name(key, index: index, env_name: env_name)}"
    end

    def self.validate_array(key, value, required: false, env_name: nil, &block)
      case value
      when Array
        if block_given?
          value.each_with_index do |v, i|
            block.call(v, index: i, env_name: env_name)
          end
        end
      when nil
        raise InvalidManifest, "Missing required key: #{build_key_name(key, env_name: env_name)}" if required
      else
        raise InvalidManifest, "Expected array #{for_key(key, env_name: env_name)} but got: #{value.class}"
      end
    end

    def self.validate_string(key, value, required: true, max_length: nil, index: nil, env_name: nil)
      k = for_key(key, index: index, env_name: env_name)
      case value
      when String
        raise InvalidManifest, "String must not be empty #{k}" if required && value.empty?
        if max_length && value.length > max_length
          raise InvalidManifest, "String must not exceed #{max_length} characters #{k}"
        end
      when nil
        raise InvalidManifest, "Missing required value #{k}" if required
      else
        raise InvalidManifest, "Invalid value type: #{value.class} #{k}"
      end
    end

    def self.validate_addon_value(key, value, index: nil, env_name: nil)
      key_name = build_key_name(key, index: index, env_name: env_name)
      case value
      when String
        validate_string(key, value, required: true, index: index, env_name: env_name)
      when Hash
        validate_addon_hash(key_name, value)
      else
        raise InvalidManifest, "Expected string or object #{for_key(key, index: index, env_name: env_name)} " \
        "but got: #{value.class}"
      end
    end

    def self.validate_addon_hash(key_name, hash)
      hash.each do |key, value|
        case key.to_s
        when 'plan'
          validate_string(key, value, required: true, env_name: key_name)
        when 'as'
          validate_string(key, value, required: false, env_name: key_name)
        when 'options'
          unless value.is_a?(Hash)
            raise InvalidManifest, "Expected object #{for_key(key, env_name: key_name)} but got: #{value.class}"
          end
        else
          raise InvalidManifest, "Unknown key: #{build_key_name(key, env_name: key_name)}"
        end
      end
    end

    def self.validate_env(key, value, env_name: nil)
      case value
      when Hash
        value.each do |k, v|
          validate_string(key, k, env_name: env_name)
        end
      when nil
      else
        raise InvalidManifest, "Expected object #{for_key(key, env_name: env_name)} but got: #{value.class}"
      end
    end

    def self.validate_environments(key, value)
      case value
      when Hash
        value.each do |env_name, env_value|
          (%w[test review].include? env_name.to_s) || raise(InvalidManifest, "Invalid environment name: #{env_name}")
          do_validate(env_value, env_name: "#{key}[#{env_name}]")
        end
      when nil
      else
        raise InvalidManifest, "Expected object for key environments but got: #{value.class}"
      end
    end
  end
end
