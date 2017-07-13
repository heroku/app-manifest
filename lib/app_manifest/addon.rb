module AppManifest
  class Addon
    include Virtus.model
    include Hasherator

    attribute :plan,    String
    attribute :as,      String
    attribute :options, Hash
  end
end
