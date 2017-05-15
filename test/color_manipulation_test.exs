defmodule ColorManipulationTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized
  doctest CssColors

  import CssColors.Color

  test "opacify" do
    assert hsl(0, 0, 0, 1) |> opacify(1) == hsl(0, 0, 0, 1)
    assert hsl(0, 0, 0, 0) |> opacify(1) == hsl(0, 0, 0, 1)
    assert hsl(0, 0, 0, 0.4) |> opacify(0.1) == hsl(0, 0, 0, 0.5)
    assert hsl(0, 0, 0, 0.8) |> opacify(0.01) == hsl(0, 0, 0, 0.81)
  end

  test "tranparentize" do
    assert hsl(0, 0, 0, 1) |> transparentize(1) == hsl(0, 0, 0, 0)
    assert hsl(0, 0, 0, 0) |> transparentize(1) == hsl(0, 0, 0, 0)
    assert hsl(0, 0, 0, 0.4) |> transparentize(0.1) == hsl(0, 0, 0, 0.4-0.1)
    assert hsl(0, 0, 0, 0.8) |> transparentize(0.01) == hsl(0, 0, 0, 0.79)
  end

  test "lighten" do
    assert hsl(0, 0, 1) |> lighten(1) == hsl(0, 0, 1)
    assert hsl(0, 0, 0) |> lighten(1) == hsl(0, 0, 1)
    assert hsl(0, 0, 0.4) |> lighten(0.1) == hsl(0, 0, 0.5)
    assert hsl(0, 0, 0.8) |> lighten(0.01) == hsl(0, 0, 0.81)
  end

  test "darken" do
    assert hsl(0, 0, 1) |> darken(1) == hsl(0, 0, 0)
    assert hsl(0, 0, 0) |> darken(1) == hsl(0, 0, 0)
    assert hsl(0, 0, 0.4) |> darken(0.1) == hsl(0, 0, 0.4-0.1)
    assert hsl(0, 0, 0.8) |> darken(0.01) == hsl(0, 0, 0.79)
  end

  test "adjust hue" do
    assert hsl(0, 0, 0) |> adjust_hue(1.5) == hsl(1.5, 0, 0)
    assert hsl(0, 0, 0) |> adjust_hue(100) == hsl(100, 0, 0)
    assert hsl(0, 0, 0) |> adjust_hue(180) == hsl(180, 0, 0)
    assert hsl(0, 0, 0) |> adjust_hue(360) == hsl(0, 0, 0)
    assert hsl(350, 0, 0) |> adjust_hue(350) == hsl(340, 0, 0)
  end

  test "greyscale" do
    assert hsl(0, 0.0, 0) |> grayscale() == hsl(0, 0, 0)
    assert hsl(30, 0.1, 0) |> grayscale() == hsl(30, 0, 0)
    assert hsl(80, 0.5, 0) |> grayscale() == hsl(80, 0, 0)
    assert hsl(300, 1.0, 0) |> grayscale() == hsl(300, 0, 0)
  end

  test "complement" do
    assert hsl(0, 0.5, 0) |> complement() == hsl(180, 0.5, 0)
    assert hsl(30, 0.5, 0) |> complement() == hsl(210, 0.5, 0)
    assert hsl(80, 0.5, 0) |> complement() == hsl(260, 0.5, 0)
    assert hsl(300, 0.5, 0) |> complement() == hsl(120, 0.5, 0)
  end

  test "adjust" do
    assert hsl(0, 0.5, 0) |> complement() == hsl(180, 0.5, 0)
    assert hsl(30, 0.5, 0) |> complement() == hsl(210, 0.5, 0)
    assert hsl(80, 0.5, 0) |> complement() == hsl(260, 0.5, 0)
    assert hsl(300, 0.5, 0) |> complement() == hsl(120, 0.5, 0)
  end

  test "mix" do
    assert rgb(100, 0, 0) == mix(rgb(0, 0, 0), rgb(200, 0, 0))
    assert parse("purple") |> to_string == mix(parse("#f00"), parse("#00f")) |> to_string
    assert parse("gray") |> to_string == mix(parse("#f00"), parse("#0ff")) |> to_string
    assert parse("#809155") |> to_string == mix(parse("#f70"), parse("#0aa")) |> to_string
    assert parse("#4000bf") |> to_string == mix(parse("#f00"), rgb(0, 0, 255), 0.25)  |> to_string
    assert parse("rgba(64, 0, 191, 0.75)") |> to_string == mix(rgb(255, 0, 0, 0.5), parse("#00f")) |> to_string

    assert parse("red") == mix(parse("#f00"), parse("#00f"), 1)
    assert parse("blue") == mix(parse("#f00"), parse("#00f"), 0)
    assert parse("rgba(255, 0, 0, 0.5)") == mix(parse("#f00"), transparentize(parse("#00f"), 1))
    assert parse("rgba(0, 0, 255, 0.5)") == mix(transparentize(parse("#f00"), 1), parse("#00f"))
    assert parse("red") == mix(parse("#f00"), transparentize(parse("#00f"), 1), 1)
    assert parse("blue") == mix(transparentize(parse("#f00"), 1), parse("#00f"), 0)
    assert parse("rgba(0, 0, 255, 0)") == mix(parse("#f00"), transparentize(parse("#00f"), 1), 0)
    assert parse("rgba(255, 0, 0, 0)") == mix(transparentize(parse("#f00"), 1), parse("#00f"), 1)
  end
end
