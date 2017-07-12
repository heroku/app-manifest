require 'test_helper'

module AppManifest
  class ManifestTest < MiniTest::Test
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

    def test_flat_attributes
      manifest = Manifest.new(
        name: 'my-awesome-app',
        description: 'super duper awesome',
        keywords: ['awesome', 9000]
      )

      assert_equal(manifest.name, 'my-awesome-app')
      assert_equal(manifest.description, 'super duper awesome')
      assert_equal(manifest.keywords, %w(awesome 9000))
      assert_nil(manifest.website)
    end

    def test_manifest_addons
      manifest = Manifest.new(addons: [{ plan: 'heroku-postgresql' }])

      assert_kind_of(Array, manifest.addons)
      assert_kind_of(Addon, manifest.addons.first)
    end

    def test_manifest_buildpacks
      manifest = Manifest.new(buildpacks: [{ url: 'heroku/ruby' }])

      assert_kind_of(Array, manifest.buildpacks)
      assert_kind_of(Buildpack, manifest.buildpacks.first)
    end
  end
end
