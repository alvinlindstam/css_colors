defmodule CssColors.Color do
  @moduledoc false

  alias CssColors.{RGB, HSL}

  @rgb_fields [:red, :green, :blue, :alpha]
  @hsl_fields [:hue, :saturation, :lightness, :alpha]

  def rgb(color=%RGB{}) do
    color
  end
  def rgb(hsl=%HSL{}) do
    {red, green, blue, alpha} = HSL.to_rgba(hsl)
    rgb(red, green, blue, alpha)
  end

  def hsl(color=%HSL{}) do
    color
  end
  def hsl(rgb=%RGB{alpha: alpha}) do
    {h, s, l} = RGB.to_hsl(rgb)
    hsl(h, s, l, alpha)
  end

  # Getter functions
  def red(color), do: get_attribute(color, :red)
  def green(color), do: get_attribute(color, :green)
  def blue(color), do: get_attribute(color, :blue)
  def hue(color), do: get_attribute(color, :hue)
  def saturation(color), do: get_attribute(color, :saturation)
  def lightness(color), do: get_attribute(color, :lightness)
  def alpha(color), do: get_attribute(color, :alpha)

  def get_attribute(color, key) do
    color
    |> cast_color_by_attribute(key)
    |> Map.fetch!(key)
  end

  defp cast_color_by_attribute(color, :alpha), do: color
  defp cast_color_by_attribute(color, attribute) when attribute in @rgb_fields, do: rgb(color)
  defp cast_color_by_attribute(color, attribute) when attribute in @hsl_fields, do: hsl(color)

  defdelegate rgb(red, green, blue), to: RGB
  defdelegate rgb(red, green, blue, alpha), to: RGB

  defdelegate hsl(hue, saturation, lightness), to: HSL
  defdelegate hsl(hue, saturation, lightness, alpha), to: HSL

  defdelegate parse(string), to: CssColors.Parser
end
