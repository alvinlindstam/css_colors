defmodule CssColors.Color do
  @moduledoc false

  alias CssColors.{RGB, HSL}

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

  defdelegate rgb(red, green, blue), to: RGB
  defdelegate rgb(red, green, blue, alpha), to: RGB

  defdelegate hsl(hue, saturation, lightness), to: HSL
  defdelegate hsl(hue, saturation, lightness, alpha), to: HSL

  defdelegate parse(string), to: CssColors.Parser
end
