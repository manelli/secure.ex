defmodule Secure do
  use Bitwise

  @spec random_bytes(pos_integer) :: binary
  @doc """
  Generates a binary of random bytes.

  Returns a binary of 16 random bytes as default.
  See: http://erlang.org/doc/man/crypto.html#strong_rand_bytes-1
  """
  def random_bytes(n \\ 16) do
    :crypto.strong_rand_bytes(n)
  end

  @spec base64(integer) :: bitstring
  @doc """
  Generates a random base64 string.

  The argument specifies the length, in bytes,
  of the random number to be generated (defaults to 16).
  """
  def base64(n \\ 16) do
    random_bytes(n)
    |> :base64.encode_to_string
    |> to_string
  end

  @spec urlsafe_base64(pos_integer) :: binary
  @doc """
  Generates a random URL-safe base64 string.

  The argument specifies the length, in bytes,
  of the random number to be generated (defaults to 16).
  """
  def urlsafe_base64(n \\ 16) do
    base64(n)
    |> String.replace(~r/[\n\=]/, "")
    |> String.replace(~r/\+/, "-")
    |> String.replace(~r/\//, "_")
  end

  @spec compare(atom, atom) :: false
  @spec compare(binary, binary) :: boolean
  @doc """
  Constant time string comparison.

  This function executes in constant time only
  when the two strings have the same length.
  It short-circuits when they have different lengths.

  Note that this does not prevent an attacker
  from discovering the length of the strings.

  Returns `true` if the two strings are equal, `false` otherwise.
  """
  def compare(x, y) when is_nil(x) or is_nil(y), do: false
  def compare(x, y) when is_binary(x) and is_binary(y) do
    if byte_size(x) != byte_size(y) do
      false
    else
      x_list = String.to_char_list(x)
      y_list = String.to_char_list(y)

      0 == Enum.zip(x_list, y_list) |> Enum.reduce(0, fn({x_byte, y_byte}, acc) ->
        acc ||| bxor(x_byte, y_byte)
      end)
    end
  end

  @spec uuid() :: bitstring
  @doc """
  Generates a version 4 (random) UUID.

  This type of UUID doesn’t contain meaningful information
  such as MAC address, time, etc.
  """
  def uuid do
    bingenerate() |> encode
  end

  # Generates a version 4 (random) UUID in the binary format.
  # See: https://hexdocs.pm/ecto/Ecto.UUID.html#bingenerate/0
  @spec bingenerate() :: bitstring
  defp bingenerate do
    <<u0::48, _::4, u1::12, _::2, u2::62>> = :crypto.strong_rand_bytes(16)
    <<u0::48, 4::4, u1::12, 2::2, u2::62>>
  end

  # Encodes binary version 4 (random) UUID to a formatted string
  # in downcased 8-4-4-4-12 format.
  @spec encode(bitstring) :: bitstring
  defp encode(<<u0::32, u1::16, u2::16, u3::16, u4::48>>) do
    hex_pad(u0, 8) <> "-" <>
    hex_pad(u1, 4) <> "-" <>
    hex_pad(u2, 4) <> "-" <>
    hex_pad(u3, 4) <> "-" <>
    hex_pad(u4, 12)
  end

  defp hex_pad(hex, count) do
    hex = Integer.to_string(hex, 16)
    lower(hex, :binary.copy("0", count - byte_size(hex)))
  end

  defp lower(<<h, t::binary>>, acc) when h in ?A..?F,
    do: lower(t, acc <> <<h + 32>>)
  defp lower(<<h, t::binary>>, acc),
    do: lower(t, acc <> <<h>>)
  defp lower(<<>>, acc), do: acc

end
