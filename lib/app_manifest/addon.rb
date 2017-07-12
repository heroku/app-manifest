module AppManifest
  class Addon
    include Virtus.model

    attribute :plan, String
    attribute :as, String
    attribute :options, Hash
  end
end
