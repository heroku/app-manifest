module AppManifest
  class Buildpack
    include Virtus.model
    include Hasherator

    attribute :url, String
  end
end
