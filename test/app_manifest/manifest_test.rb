require 'test_helper'

module AppManifest
  class ManifestTest < EnvironmentTest
    def environment_class
      Manifest
    end

    def test_initialize
      manifest = AppManifest::Manifest.new(name: 'my-app')
      assert_kind_of(AppManifest::Manifest, manifest)
    end

    def test_initialize__canonicalizes_hash
      manifest = AppManifest::Manifest.new(env: { 'BAR' => 'BAZ' })
      env = manifest.to_hash.fetch(:env)
      assert_equal(env, 'BAR' => { value: 'BAZ' })
    end

    def test_environment__when_present
      hash = { environments: { test: { addons: [{ plan: 'a' }] } } }
      manifest = AppManifest::Manifest.new(hash)
      test_manifest = manifest.environment(:test)
      assert_equal(test_manifest.to_hash.fetch(:addons), [plan: 'a'])
    end

    def test_environment__when_missing
      hash = { addons: [{ plan: 'a' }] }
      manifest = AppManifest::Manifest.new(hash)
      foo_manifest = manifest.environment(:foo)
      assert_equal(foo_manifest.to_hash.fetch(:addons), [plan: 'a'])
    end

    def test_environments
      hash = { environments: { test: { addons: [{ plan: 'a' }] } } }
      manifest = Manifest.new(hash)

      assert_kind_of(Hash, manifest.environments)
      assert_kind_of(String, manifest.environments.keys.first)
      assert_kind_of(Environment, manifest.environments.values.first)
    end

    def test_to_hash
      hash = { 
        name: 'foo',
        environments: {
          'test' => {
            addons: [{ plan: 'heroku-postgresql'}]
          }
        },
        scripts: {
          'postdeploy' => "echo 'success'"
        },
        buildpacks: [
          { url: "heroku-ruby" }
        ]
      }

      manifest = Manifest.new(hash)

      assert_equal(hash, manifest.to_hash)
    end
  end
end
