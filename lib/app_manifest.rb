require 'multi_json'

require "app_manifest/version"
require "app_manifest/manifest"
require "app_manifest/schema"

# Create a new manifest from json string or a hash
def AppManifest(input)
  if input.is_a?(Hash)
    AppManifest::Manifest.new(input)
  elsif input.is_a?(String)
    AppManifest::Manifest.from_json(input)
  end
end

module AppManifest
  class << self
    # Takes a hash representing an app manifest and returns a new hash
    # with canonical serialization. This will resolve shorthands and older
    # serializations into a canonical serialization.
    def canonicalize(manifest)
      manifest = keys_to_sym(manifest)
      manifest
        .merge(canonicalize_env(manifest))
        .merge(canonicalize_formation(manifest))
        .merge(canonicalize_addons(manifest))
        .merge(canonicalize_environments(manifest))
    end

    private

    # Takes an env serialization returns a new serialization hash in the
    # canonical format.
    # For instance:
    # canonicalize_env({"FOO" => "BAR"}) # => { "FOO" => { value: "BAR" } }
    def canonicalize_env(manifest)
      canonicalize_key(manifest, :env) do |env|
        Hash[
          env.map do |key, value|
            if value.is_a?(String) || [true, false].include?(value)
              value = {
                value: value,
              }
            end
            [key.to_s, value]
          end
        ]
      end
    end

    # Takes a formation serialization and returns a new serializaiton in the
    # standard format.
    # For example:
    # canonicalize_formation([{ "process" => "web", "count" => 1 }]
    # # => { web: { count: 1 } }
    def canonicalize_formation(manifest)
      canonicalize_key(manifest, :formation) do |formation|
        if formation.is_a? Array
          Hash[
            formation
            .map { |entry| keys_to_sym(entry) }
            .reject { |entry| entry[:process].to_s.empty? }
            .map do |entry|
              process = entry.fetch(:process)
              entry = entry.reject { |k, _| k == :process }
              [process.to_sym, entry]
            end
          ]
        else
          formation
        end
      end
    end

    # Takes an addon serialization and returns a new serialization in the
    # canonical format.
    # For example:
    # canonicalize_addons(["heroku-postgres:hobby-dev"])
    # # => { plan: "heroku-postgres:hobby-dev" }
    def canonicalize_addons(manifest)
      canonicalize_key(manifest, :addons) do |addons|
        addons.map do |entry|
          if entry.is_a? String
            {
              plan: entry,
            }
          else
            keys_to_sym(entry)
          end
        end
      end
    end


    # Takes an environments serialization and canonicalizes each entry.
    def canonicalize_environments(manifest)
      canonicalize_key(manifest, :environments) do |environments|
        Hash[
          environments.map do |key, environment|
            [key, canonicalize(environment)]
          end
        ]
      end
    end

    # Takes a hash, a key in that hash, and a block. If the key is present, runs
    # the corresponding value through the block and returns a new hash with the
    # canonicalized value. (This can be merged into the original hash using
    # .update.) Otherwise, returns an empty hash.
    def canonicalize_key(manifest, key)
      if manifest.has_key? key
        val = manifest[key]
        {
          key => yield(val),
        }
      else
        {}
      end
    end

    # Takes a (possibly nested) hash whose keys respond to to_sym
    # Returns a hash where all levels of hashes have only symbol keys
    #
    # {"a" => 1, "b" => { "c" => 2 }}
    #  => {:a => 1, :b => { :c => 2 }}
    #
    # This special-cases the immediate children of any key named 'env' or :env,
    # so that env var names remain (or become) strings.
    #
    # {'env' => { 'a' => { 'b' => 2 }}}
    # => {:env => { 'a' => { :b => 2 }}}
    def keys_to_sym(hash)
      Hash[
        hash.map do |key, val|
          [
            key.to_sym,
            if ['env', :env].include? key
              env_to_sym(val)
            else
              val_to_sym(val)
            end
          ]
        end
      ]
    end

    def keys_to_string(hash)
      Hash[
        hash.map do |key, val|
          [key.to_s, val_to_sym(val)]
        end
      ]
    end

    def val_to_sym(value)
      if value.is_a? Hash
        keys_to_sym(value)
      else
        value
      end
    end

    def env_to_sym(value)
      if value.is_a? Hash
        keys_to_string(value)
      else
        value
      end
    end
  end
end
