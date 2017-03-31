require 'test_helper'

class AppManifestTest < Minitest::Test
  def test_App_Manifest_hash
    manifest = AppManifest(name: 'my-app')
    assert_equal(manifest.to_hash.fetch(:name), 'my-app')
  end

  def test_App_Manifest_json
    manifest = AppManifest('{ "name": "my-app" }')
    assert_equal(manifest.to_hash.fetch(:name), 'my-app')
  end

  def test_that_it_has_a_version_number
    refute_nil ::AppManifest::VERSION
  end

  def test_canonicalize__addon_shorthand
    canonicalized = AppManifest.canonicalize(addons: ['a', 'b'])
    assert_equal(canonicalized, addons: [{ plan: 'a' }, { plan: 'b' }])
  end

  def test_canonicalizing__addon_shorthand_leave_options_intact
    canonicalized = AppManifest.canonicalize(addons: [
      {
        options: {
          version: "9.5"
        }
      }
    ])
    assert_equal(canonicalized, addons: [ options: { version: "9.5" } ])
  end

  def test_canonicalize__env_shorthand
    canonicalized = AppManifest.canonicalize(env: { 'foo' => 'bar' })
    assert_equal(canonicalized, env: { 'foo' => { value: 'bar' } })
  end

  def test_canonicalize__env_shorthand_boolean
    canonicalized = AppManifest.canonicalize(env: { 'foo' => true })
    assert_equal(canonicalized, env: { 'foo' => { value: true } })
  end

  def test_canonicalize__legacy_formation
    manifest = { formation: [{ process: 'web', quantity: 5 }] }
    canonicalized = AppManifest.canonicalize(manifest)
    assert_equal(canonicalized, formation: { web: { quantity: 5 } })
  end

  def test_canonicalize__environments
    canonicalized = AppManifest.canonicalize(
      environments: {
        foo: {
          addons: ['a'],
          env: { foo: 'bar' }
        }
      }
    )
    expected = {
      environments: {
        foo: {
          addons: [{ plan: 'a' }],
          env: { 'foo' => { value: 'bar' } }
        }
      }
    }
    assert_equal(canonicalized, expected)
  end

  def test_canonicalize__symbolize
    canonicalized = AppManifest.canonicalize('env' => { 'foo' => 'bar' })
    assert_equal(canonicalized, env: { 'foo' => { value: 'bar' } })
  end

  def test_canonicalize__deep_symbolize_addons
    canonicalized = AppManifest.canonicalize(
      'addons' => [{
        'plan' => 'heroku-postgres:hobby-dev',
        'options' => {
          'version' => '9.2'
        }
      }]
    )
    assert_equal(canonicalized,
      addons: [{
        plan: 'heroku-postgres:hobby-dev',
        options: {
          version: '9.2'
        }
      }]
    )
  end

  def test_canonicalize__deep_symbolize_formation
    canonicalized = AppManifest.canonicalize(
      'formation' => {
        'web' => {
          'quantity' => 1
        }
      }
    )
    assert_equal(canonicalized,
      formation: {
        web:{
          quantity: 1
        }
      }
    )
  end

  def test_canonicalize__deep_symbolize_legacy_formation
    canonicalized = AppManifest.canonicalize(
      'formation' => [{
        'process' => 'web',
        'quantity' => 1
      }]
    )
    assert_equal(canonicalized,
      formation: {
        web:{
          quantity: 1
        }
      }
    )
  end

  def test_canonicalize__formation_missing_process
    canonicalized = AppManifest.canonicalize(
      'formation' => [{ 'quantity' => 1 }]
    )
    assert_equal(canonicalized, formation: {})
  end
end
