require 'test_helper'

module AppManifest
  class AddonTest < MiniTest::Test
    def test_attributes
      addon = AppManifest::Addon.new(
        plan: 'foo:bar',
        as: 'baz',
        options: { version: 9000 }
      )

      assert_equal(addon.plan, 'foo:bar')
      assert_equal(addon.as, 'baz')
      assert_equal(addon.options, version: 9000)
    end
  end
end
