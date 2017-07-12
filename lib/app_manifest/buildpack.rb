module AppManifest
  class Buildpack
    include Virtus.model

    attribute :url, String
  end
end
