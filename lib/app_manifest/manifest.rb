
module AppManifest
  # A simple model-like wrapper around a manifest hash.
  class Manifest
    def self.from_json(string)
      hash = MultiJson.load(string)
      self.new(hash)
    end

    attr_reader :errors

    def initialize(hash)
      @manifest = AppManifest.canonicalize(hash)
    end

    def validate
      @errors = AppManifest::Schema.validate(@manifest)
    end

    def validate!

    end

    def environment(name)
      env_manifest = manifest.fetch(:environments, {}).fetch(name, {})
      self.class.new(manifest.merge(env_manifest))
    end

    def to_hash
      manifest
    end

    private

    attr_reader :manifest
  end
end
