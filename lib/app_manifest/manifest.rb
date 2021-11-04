require "app_manifest/manifest_validator"

module AppManifest
  # A simple model-like wrapper around a manifest hash.
  class Manifest
    include Virtus.model
    include EnvironmentAttributes
    include Serializer

    attribute :environments, Hash[String => Environment], default: nil

    def self.from_json(string)
      hash = MultiJson.load(string)
      new(hash)
    end

    def initialize(hash, validate: true)
      AppManifest::ManifestValidator.validate!(hash) if validate
      canonicalized = AppManifest.canonicalize(hash)
      super(canonicalized)
    end

    def environment(name)
      scoped_data = (environments || {}).fetch(name.to_s, {}).to_hash
      global_data = to_hash
      Environment.new(global_data.merge(scoped_data))
    end

    def environments?
      !environments.nil?
    end
  end
end
