defmodule ExBencode do
  @moduledoc """
  Documentation for `ExBencode`.
  """

  @doc """
  Encoding string

  ## Examples

      iex> ExBencode.encode("myterm")
      ["6", 58, "myterm"]
  """
  def encode(term) when is_binary(term) do
    [term |> byte_size |> Integer.to_string(), ?:, term]
  end

  @doc """
  Encoding nil to null

  ## Examples

      iex> ExBencode.encode(nil)
      ["4", 58, "null"]
  """
  def encode(nil) do
    encode("null")
  end

  @doc """
  Encoding atom

  ## Examples

      iex> ExBencode.encode(:myterm)
      ["6", 58, "myterm"]
  """
  def encode(atom) when is_atom(atom) do
    atom |> Atom.to_string() |> encode()
  end

  @doc """
  Encoding integer

  ## Examples

      iex> ExBencode.encode(123)
      [105, "123", 101]
  """
  def encode(term) when is_integer(term) do
    [?i, Integer.to_string(term), ?e]
  end

  @doc """
  Encoding lists

  ## Examples

      iex> ExBencode.encode(["one", 2, "three"])
      [108, [["3", 58, "one"], [105, "2", 101], ["5", 58, "three"]], 101]
  """
  def encode(list) when is_list(list) do
    list
    |> Enum.map(&encode/1)
    |> (fn encoded -> [?l, encoded, ?e] end).()
  end

  @doc """
  Encoding maps

  ## Examples

      iex> ExBencode.encode(%{green: "eggs", ham: 4})
      [
        100,
        [[["5", 58, "green"], ["4", 58, "eggs"]], [["3", 58, "ham"], [105, "4", 101]]],
        101
      ]
      iex> ExBencode.encode(%{})
      [100, 101]
  """
  def encode(map) when is_map(map) and map_size(map) == 0, do: [?d, ?e]
  def encode(map) when is_map(map) do
    map
    |> Map.keys()
    |> Enum.sort()
    |> Enum.map(fn key -> [encode(key), encode(Map.get(map, key))] end)
    |> (fn encoded -> [?d, encoded, ?e] end).()
  end
end
