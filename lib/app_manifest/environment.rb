module AppManifest
  class Environment
    include Virtus.model
    include EnvironmentAttributes
    include Serializer
  end
end
