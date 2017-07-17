require 'test_helper'

module AppManifest
  class SerializerTest < MiniTest::Test

    def test_serialize_hash
      h = { foo: 'bar' }
      assert_equal(h, Serializer.serialize(h))
    end

    def test_serialize_array
      a = [1, 2, "foo", nil]
      assert_equal(a, Serializer.serialize(a))
    end

    def test_serialize_virtus_model_with_nil
      widget_class = Class.new
      widget_class.include(Virtus.model)
      widget_class.attribute(:size, String)
      widget_class.attribute(:color, String)
      widget = widget_class.new(size: 'large', color: nil)

      expected = { size: 'large' }
      actual = Serializer.serialize(widget)

      assert_equal(expected, actual)
    end

    def test_serialize_virtus_model_with_hash
      widget_class = Class.new
      widget_class.include(Virtus.model)
      widget_class.attribute(:sizes, Hash[Symbol => Integer], default: nil)
      widget_class.attribute(:options, Hash[String => String], default: nil)
      widget = widget_class.new(sizes: { small: 4 })

      expected = { sizes: { small: 4 } }
      actual   = Serializer.serialize(widget)

      assert_equal(expected, actual)
    end

    def test_serialize_model_with_nullable_array
      widget_class = Class.new
      widget_class.include(Virtus.model)
      widget_class.attribute(:sizes, NullableArray[Symbol])
      widget_class.attribute(:options, NullableArray[String])
      widget = widget_class.new(sizes: %i(small medium large))

      expected = { sizes: %i(small medium large) }
      actual   = Serializer.serialize(widget)

      assert_equal(expected, actual)
    end

    def test_serialize_model_nested_model
      size_class = Class.new
      size_class.include(Virtus.model)
      size_class.attribute(:label, String)

      widget_class = Class.new
      widget_class.include(Virtus.model)
      widget_class.attribute(:size, size_class)

      widget = widget_class.new(size: { label: 'large' })

      expected = { size: { label: 'large' } }
      actual   = Serializer.serialize(widget)

      assert_equal(expected, actual)
    end
  end
end
