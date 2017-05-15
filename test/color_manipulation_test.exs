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
end
