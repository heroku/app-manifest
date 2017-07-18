module AppManifest
  class Buildpack
    include Virtus.model
    include Serializer

    attribute :url, String
  end
end
