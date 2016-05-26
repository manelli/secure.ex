defmodule BcryptTest do
  use ExUnit.Case, async: true
  doctest Secure.Bcrypt

  test "Secure.Bcrypt.salt" do
    assert is_bitstring(Secure.Bcrypt.salt)
  end

  test "Secure.Bcrypt.hash" do
    assert is_bitstring(Secure.Bcrypt.hash("password"))
  end

  test "Secure.Bcrypt.match" do
    password = "hunter2"
    hash = Secure.Bcrypt.hash(password)

    assert Secure.Bcrypt.match(password, hash)
    refute Secure.Bcrypt.match("bad_pwd", hash)
  end

  test "Secure.Bcrypt.change_factor" do
    password = "hunter2"
    hash = Secure.Bcrypt.hash(password)

    assert is_bitstring(Secure.Bcrypt.change_factor(password, hash, 6))
    assert {:error, "Bad Password"} == Secure.Bcrypt.change_factor("bad_pwd", hash, 6)
  end

  test "Secure.Bcrypt.change_password" do
    password = "hunter2"
    hash = Secure.Bcrypt.hash(password)

    assert is_bitstring(Secure.Bcrypt.change_password(password, hash, "new_pwd"))
    assert {:error, "Bad Password"} == Secure.Bcrypt.change_factor("bad_pwd", hash, "new_pwd")
  end

end
