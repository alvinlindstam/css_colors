defmodule EctoColorsTest do
  use ExUnit.Case

  @existing_rgb_color CssColors.rgb(10, 50, 200)
  @existing_hsl_color CssColors.hsl(10, 0.5, 0.5)

  test "cast" do
    {:ok, %CssColors.RGB{}} = CssColors.Ecto.Color.cast("#abc")
    {:ok, %CssColors.HSL{}} = CssColors.Ecto.Color.cast("hsl(30, 50%, 50%)")
    :error = CssColors.Ecto.Color.cast("")
    :error = CssColors.Ecto.Color.cast("#")
    :error = CssColors.Ecto.Color.cast("#ab")
    {:ok, @existing_rgb_color} = CssColors.Ecto.Color.cast(@existing_rgb_color)
    {:ok, @existing_hsl_color} = CssColors.Ecto.Color.cast(@existing_hsl_color)
  end

  test "load" do
    {:ok, %CssColors.RGB{}} = CssColors.Ecto.Color.load("#abc")
    {:ok, %CssColors.HSL{}} = CssColors.Ecto.Color.load("hsl(30, 50%, 50%)")
  end

  test "dump" do
    assert {:ok, to_string(@existing_rgb_color)} == CssColors.Ecto.Color.dump(@existing_rgb_color)
    assert {:ok, to_string(@existing_hsl_color)} == CssColors.Ecto.Color.dump(@existing_hsl_color)
    :error = CssColors.Ecto.Color.dump(%{})
  end
end
