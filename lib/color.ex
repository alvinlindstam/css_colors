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

  # Sass hsl functions
  def opacify(color, amount) do
    adjust(color, amount, :alpha, &+/2)
  end

  def transparentize(color, amount) do
    adjust(color, amount, :alpha, &-/2)
  end
  
  def lighten(color, amount) do
    adjust(color, amount, :lightness, &+/2)
  end

  def darken(color, amount) do
    adjust(color, amount, :lightness, &-/2)
  end

  def saturate(color, amount) do
    # Support the filter effects definition of saturate.
    # https://dvcs.w3.org/hg/FXTF/raw-file/tip/filters/index.html
    #return identifier("saturate(#{color})") if amount.nil?
    adjust(color, amount, :saturation, &+/2)
  end

  def desaturate(color, amount) do
    adjust(color, amount, :saturation, &-/2)
  end

  def adjust_hue(color, degrees) do
    adjust(color, degrees, :hue, &+/2)
  end

  def grayscale(color) do
    # if color.is_a?(Sass::Script::Value::Number)
    #   return identifier("grayscale(#{color})")
    # end
    desaturate color, 1
  end

  def complement(color) do
    adjust_hue color, 180
  end

  # Getter functions
  def red(color), do: get_attribute(color, :red)
  def green(color), do: get_attribute(color, :green)
  def blue(color), do: get_attribute(color, :blue)
  def hue(color), do: get_attribute(color, :hue)
  def saturation(color), do: get_attribute(color, :saturation)
  def lightness(color), do: get_attribute(color, :lightness)
  def alpha(color), do: get_attribute(color, :alpha)

  # sass rgb functions

  def invert(color) do
    rgb_color = rgb(color)
    rgb(255 - rgb_color.red, 255 - rgb_color.green, 255 - rgb_color.blue, color.alpha)
  end

  def mix(color1, color2, weight\\0.5) do
    # Algorithm taken from the sass function.

    p = weight
    w = p * 2 - 1
    a = color1.alpha - color2.alpha

    w1 = ((if (w * a == -1), do: w, else: (w + a) / (1 + w * a)) + 1) / 2.0
    w2 = 1 - w1

    [r, g, b] =
      [:red, :green, :blue]
      |> Enum.map(fn(key)->
          get_attribute(color1, key) * w1 + get_attribute(color2, key) * w2
        end)

    alpha = alpha(color1) * p + alpha(color2) * (1 - p)
    rgb(r, g, b, alpha)
  end

  def get_attribute(color, key) do
    color
    |> cast_color_by_attribute(key)
    |> Map.fetch!(key)
  end

  def adjust(struct, amount, field, operator) do
    struct = cast_color_by_attribute(struct, field)
    new_value =
      struct
      |> Map.fetch!(field)
      |> operator.(amount)
      |> struct.__struct__.cast(field)
    Map.put(struct, field, new_value)
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
