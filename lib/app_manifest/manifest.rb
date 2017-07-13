module AppManifest
  # A simple model-like wrapper around a manifest hash.
  class Manifest < Environment
    include Virtus.model
    include Serializer

    attribute :environments, Hash[String => Environment]

    def self.from_json(string)
      hash = MultiJson.load(string)
      new(hash)
    end

    def initialize(hash)
      @manifest = AppManifest.canonicalize(hash)
      super(@manifest)
    end

    def environment(name)
      env_manifest = manifest.fetch(:environments, {}).fetch(name, {})
      self.class.new(manifest.merge(env_manifest))
    end

    private

    attr_reader :manifest
  end
end
