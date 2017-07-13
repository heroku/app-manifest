module AppManifest
  class Environment
    include Virtus.model
    include Hasherator

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
    attribute :formation,  Hash[String => Formation]
    attribute :scripts,    Hash[String => String]
  end
end
