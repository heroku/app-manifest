require 'test_helper'

module AppManifest
  class EnvironmentTest < MiniTest::Test
    def environment_class
      Environment
    end

    def test_flat_attributes
      environment = environment_class.new(
        name: 'my-awesome-app',
        description: 'super duper awesome',
        keywords: ['awesome', 9000]
      )

      assert_equal(environment.name, 'my-awesome-app')
      assert_equal(environment.description, 'super duper awesome')
      assert_equal(environment.keywords, %w(awesome 9000))
      assert_nil(environment.website)
    end

    def test_environment_addons
      environment = environment_class.new(addons: [{ plan: 'heroku-postgresql' }])

      assert_kind_of(Array, environment.addons)
      assert_kind_of(Addon, environment.addons.first)
    end

    def test_environment_buildpacks
      environment = environment_class.new(buildpacks: [{ url: 'heroku/ruby' }])

      assert_kind_of(Array, environment.buildpacks)
      assert_kind_of(Buildpack, environment.buildpacks.first)
    end

    def test_environment_env
      environment = environment_class.new(env: { 'FOO' => { value: 'bar' } })

      assert_kind_of(Hash, environment.env)
      assert_kind_of(String, environment.env.keys.first)
      assert_kind_of(Env, environment.env.values.first)
    end

    def test_environment_formation
      environment = environment_class.new(formation: { 'web' => { quantity: 1 } })

      assert_kind_of(Hash, environment.formation)
      assert_kind_of(String, environment.formation.keys.first)
      assert_kind_of(Formation, environment.formation.values.first)
    end
  end
end