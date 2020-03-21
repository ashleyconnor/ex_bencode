defmodule ExBencodeTest do
  use ExUnit.Case
  doctest ExBencode

  test "encodes strings correctly" do
    assert ExBencode.encode("mystring") == ["8", 58, "mystring"]
  end

  test "encodes integers correctly" do
    assert ExBencode.encode(0) == [105, "0", 101]
    assert ExBencode.encode(1) == [105, "1", 101]
    assert ExBencode.encode(-1) == [105, "-1", 101]
  end

  test "encodes nil correctly" do
    assert ExBencode.encode(nil) == ["4", 58, "null"]
  end

  test "encodes lists correctly" do
    assert ExBencode.encode(["one", "two", "three"]) == [
             108,
             [["3", 58, "one"], ["3", 58, "two"], ["5", 58, "three"]],
             101
           ]
  end

  test "encodes maps correctly" do
    assert ExBencode.encode(%{keyone: 1, anotherkey: "value"}) == [
             100,
             [
               [["10", 58, "anotherkey"], ["5", 58, "value"]],
               [["6", 58, "keyone"], [105, "1", 101]]
             ],
             101
           ]
  end

  test "recusively encodes complex datastructures" do
    assert ExBencode.encode(["one", %{key: %{inner: "map"}}, ["nested", "list"], 3]) == [
             108,
             [
               ["3", 58, "one"],
               [
                 100,
                 [[["3", 58, "key"], [100, [[["5", 58, "inner"], ["3", 58, "map"]]], 101]]],
                 101
               ],
               [108, [["6", 58, "nested"], ["4", 58, "list"]], 101],
               [105, "3", 101]
             ],
             101
           ]
  end
end
