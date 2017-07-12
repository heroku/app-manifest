module AppManifest
  # A simple model-like wrapper around a manifest hash.
  class Manifest
    include Virtus.model

    attribute :name,        String
    attribute :description, String
    attribute :image,       String
    attribute :keywords,    Array[String]
    attribute :logo,        String
    attribute :repository,  String
    attribute :stack,       String
    attribute :success_url, String
    attribute :website,     String

    attribute :addons,     Array[Addon]
    attribute :buildpacks, Array[Buildpack]
    attribute :env,        Hash[String => Env]

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
