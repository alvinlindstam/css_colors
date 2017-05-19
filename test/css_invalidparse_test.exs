defmodule CssInvalidParseTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  import CssColors

  test "invalid hex" do
    assert {:error, _} = parse("#")
    assert {:error, _} = parse("#1")
    assert {:error, _} = parse("#12")
    assert {:error, _} = parse("#12345")
    assert {:error, _} = parse("rgb(111")
    assert {:error, _} = parse("rgba(111")
    assert {:error, _} = parse("hsl(111")
    assert {:error, _} = parse("hsla(111")
    assert {:error, _} = parse("hsla(0, 0, 0, 0)")
    assert {:ok, _} = parse("hsla(0, 10%, 10%, 0)")
    assert {:error, _} = parse("hsla(0, 10%, 10%, 0)s")
    assert {:ok, _} = parse("rgb(0, 0, 0)")
    assert {:ok, _} = parse("rgb(0%, 0%, 0%)")
    assert {:error, _} = parse("rgb(0%, 0, 0%)")

    # todo: should we ignore leading and trailing whitespace?
    #assert {:ok, _} = parse("hsla(0, 10%, 10%, 0) ")

  end
end
