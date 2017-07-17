module AppManifest
  # A simple model-like wrapper around a manifest hash.
  class Manifest < Environment
    include Virtus.model
    include Serializer

    attribute :environments, Hash[String => Environment], default: nil

    def self.from_json(string)
      hash = MultiJson.load(string)
      new(hash)
    end

    def initialize(hash)
      canonicalized = AppManifest.canonicalize(hash)
      super(canonicalized)
    end

    def environment(name)
      scoped_data = (environments || {}).fetch(name.to_s, {}).to_hash
      global_data = to_hash
      Environment.new(global_data.merge(scoped_data))
    end
  end
end
