defmodule SecureTest do
  use ExUnit.Case, async: true
  doctest Secure

  test "Secure.random_bytes" do
    Enum.each(Range.new(1, 1000), fn(bytes) ->
      random_bytes = Secure.random_bytes(bytes)

      assert bytes == byte_size random_bytes
      assert is_binary(random_bytes)
    end)
  end

  test "Secure.base64" do
    assert is_bitstring Secure.base64
    assert byte_size(Secure.base64(3)) == 4
    assert byte_size(Secure.base64(16)) == 24
  end

  test "Secure.urlsafe_base64" do
    not_safe = ~r/[\n+\/]/

    Enum.each(Range.new(1, 1000), fn(bytes) ->
      urlsafe_b64 = Secure.urlsafe_base64(bytes)

      refute Regex.match?(not_safe, urlsafe_b64)
      assert is_binary(urlsafe_b64)
    end)
  end

  test "Secure.uuid" do
    uuid = Secure.uuid

    assert Regex.match?(~r/\A\w{8}-\w{4}-\w{4}-\w{4}-\w{12}\z/, uuid)
    assert 36 == String.length uuid
    assert is_bitstring(uuid)
  end

  test "Secure.compare" do
    assert Secure.compare("foo", "foo")
    refute Secure.compare("foo", "bar")
    refute Secure.compare("foo", "barbaz")
    refute Secure.compare("foo", nil)
    refute Secure.compare(nil, "bar")
    refute Secure.compare(nil, nil)
  end

end
