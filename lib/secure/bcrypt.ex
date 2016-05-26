defmodule Secure.Bcrypt do

  @moduledoc """
  Elixir wrapper for the OpenBSD bcrypt password hashing algorithm.
  """

  @spec salt(pos_integer) :: bitstring
  @doc """
  Generates a salt with a given work factor.

  The work factor defaults to 12 if no factor is given.
  """
  def salt(factor \\ 12) do
    {:ok, salt} = :bcrypt.gen_salt(factor)
    List.to_string(salt)
  end

  @spec hash(binary, pos_integer) :: binary
  @doc """
  Hashes a given password with a given work factor.

  Bcrypt takes care of salting the hashes for you so this does not need to be
  done. The higher the work factor, the longer the password will take to be
  hashed and checked.
  The work factor defaults to 12 if no factor is given.
  """
  def hash(password, factor \\ 12) when is_binary(password) do
    {:ok, hash} = :bcrypt.hashpw(password, salt(factor))
    List.to_string(hash)
  end

  @spec match(binary, binary) :: boolean
  @doc """
  Compares a given password to a hash.

  Returns `true` if the password matches, `false` otherwise.
  The comparison is done in constant time (based on the hash length).
  """
  def match(password, hash) when is_binary(password) and is_binary(hash) do
    {:ok, res_hash} = :bcrypt.hashpw(password, String.to_char_list(hash))
    Secure.compare(hash, List.to_string(res_hash))
  end

  @spec change_factor(binary, binary, pos_integer) :: bitstring | {:error, binary}
  @doc """
  Changes the work factor of a hash.

  If a given password matches a given hash, the password is re-hashed again
  using the new work_factor.
  """
  def change_factor(password, hash, factor) when is_binary(password) and is_binary(hash) do
    change_password(password, hash, password, factor)
  end

  @spec change_password(binary, binary, binary, pos_integer) :: bitstring | {:error, binary}
  @doc """
  Change a password, only if the previous one was given with it.

  If a given old password matches a given old hash, a new password
  is hashed using the work factor passed in as an argument. (Defaults to 12)
  """
  def change_password(old, hash, new, factor \\ 12) when is_binary(old) and is_binary(hash) and is_binary(new) do
    if match(old, hash) do
      hash(new, factor)
    else
      {:error, "Bad Password"}
    end
  end

end
