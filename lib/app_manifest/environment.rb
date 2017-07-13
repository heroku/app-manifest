module AppManifest
  class Environment
    include Virtus.model
    include Serializer

    attribute :addons,      Array[Addon]
    attribute :buildpacks,  Array[Buildpack]
    attribute :description, String
    attribute :env,         Hash[String => Env]
    attribute :formation,   Hash[String => Formation]
    attribute :image,       String
    attribute :keywords,    Array[String]
    attribute :logo,        String
    attribute :name,        String
    attribute :repository,  String
    attribute :scripts,     Hash[String => String]
    attribute :stack,       String
    attribute :success_url, String
    attribute :website,     String
  end
end
