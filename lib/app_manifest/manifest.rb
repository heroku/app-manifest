module AppManifest
  # A simple model-like wrapper around a manifest hash.
  class Manifest < Environment
    include Virtus.model

    def self.from_json(string)
      hash = MultiJson.load(string)
      self.new(hash)
    end

    def initialize(hash)
      @manifest = AppManifest.canonicalize(hash)
      super(@manifest)
      @manifest
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
