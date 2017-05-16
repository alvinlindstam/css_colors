defmodule CssColors.Color do
  @moduledoc """
  This module contains functions for creating and manipulating colors.

  Colors are represented as either `CSSColors.RGB` or `CSSColors.HSL` structs. Any function in this
  module can handle both representations, trasforming it to the necessary representation as necessary.

  ## Examples:

      iex> color = parse("#123456")
      %CssColors.RGB{alpha: 1.0, blue: 86.0, green: 52.0, red: 18.0}
      iex> blue(color)
      86.0
      iex> lightness(color)
      0.20392156862745098
      iex> darken(color, 0.2)
      %CssColors.HSL{alpha: 1.0, hue: 210.0, lightness: 0.0039215686274509665,
       saturation: 0.653846153846154}
      iex> to_string lighten(color, 0.2)
      "hsl(210, 65%, 40%)"
      iex> to_string lighten(color, 0.2) |> transparentize(0.5)
      "hsla(210, 65%, 40%, 0.5)"
      iex> to_string lighten(color, 0.2) |> transparentize(0.5) |> rgb
      "rgba(36, 103, 170, 0.5)"

  """

  alias CssColors.{RGB, HSL}

  @rgb_fields [:red, :green, :blue, :alpha]
  @hsl_fields [:hue, :saturation, :lightness, :alpha]

  @typedoc """
    A representation of a color in hue, saturation, lightness and alpha.
  """
  @type hsl_color :: %HSL{
    hue: :float,
    saturation: :float,
    lightness: :float,
    alpha: :float,
  }

  @typedoc """
    A representation of a color in red, green, blue and alpha.
  """
  @type rgb_color :: %RGB{
      red: :float,
      green: :float,
      blue: :float,
      alpha: :float
    }

  @typedoc """
    A representation of a color in any supported system.
  """
  @type color :: hsl_color | rgb_color
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
  @doc """
  Makes a color more opaque.

  Takes a color and a number between 0 and 1, and returns a color with the opacity increased by that amount.

  See also `transparentize/1` for the opposite effect.
  """
  @spec opacify(color, number) :: hsl_color
  def opacify(color, amount) do
    adjust(color, amount, :alpha, &+/2)
  end

  @doc """
  Makes a color more transparent.

  Takes a color and a number between 0 and 1, and returns a color with the opacity decreased by that amount.

  See also `opacify/1` for the opposite effect.
  """
  @spec transparentize(color, number) :: color
  def transparentize(color, amount) do
    adjust(color, amount, :alpha, &-/2)
  end

  @doc """
    Makes a color lighter.

    Takes a color and a number between 0 and 1, and returns a color with the lightness increased by that amount.

    See also `darken/1` for the opposite effect.
  """
  @spec lighten(color, number) :: hsl_color
  def lighten(color, amount) do
    adjust(color, amount, :lightness, &+/2)
  end

  @doc """
    Makes a color darker.

    Takes a color and a number between 0 and 1, and returns a color with the lightness decreased by that amount.

    See also `lighten/1` for the opposite effect.
  """
  @spec darken(color, number) :: hsl_color
  def darken(color, amount) do
    adjust(color, amount, :lightness, &-/2)
  end

  @doc """
    Makes a color less saturated.

    Takes a color and a number between 0 and 100, and returns a color with the saturation decreased by that value.

    See also `desaturate/1` for the opposite effect.
  """
  @spec saturate(color, number) :: hsl_color
  def saturate(color, amount) do
    # Support the filter effects definition of saturate.
    # https://dvcs.w3.org/hg/FXTF/raw-file/tip/filters/index.html
    #return identifier("saturate(#{color})") if amount.nil?
    adjust(color, amount, :saturation, &+/2)
  end

  @doc """
    Makes a color more saturated.

    Takes a color and a number between 0 and 100, and returns a color with the saturation increased by that value.

    See also `saturate/1` for the opposite effect.
  """
  @spec desaturate(color, number) :: hsl_color
  def desaturate(color, amount) do
    adjust(color, amount, :saturation, &-/2)
  end

  @doc """
    Changes the hue of a color.

    Takes a color and a number of degrees (usually between -360 and 360), and returns a color with the hue rotated
    along the color wheel by that amount.
  """
  @spec adjust_hue(color, number) :: hsl_color
  def adjust_hue(color, degrees) do
    adjust(color, degrees, :hue, &+/2)
  end

  @doc """
    Converts a color to grayscale.

    This is identical to `desaturate(color, 1)`.
  """
  @spec grayscale(color) :: hsl_color
  def grayscale(color) do
    # if color.is_a?(Sass::Script::Value::Number)
    #   return identifier("grayscale(#{color})")
    # end
    desaturate color, 1
  end

  @doc """
    Returns the complement of a color.

    This is identical to `adjust_hue(color, 180)`.
  """
  @spec complement(color) :: hsl_color
  def complement(color) do
    adjust_hue color, 180
  end

  # Getter functions
  @doc """
    Gets the `:red` property of the color.
  """
  @spec get_red(color) :: float
  def get_red(color), do: get_attribute(color, :red)
  @doc """
    Gets the `:green` property of the color.
  """
  @spec get_green(color) :: float
  def get_green(color), do: get_attribute(color, :green)
  @doc """
    Gets the `:blue` property of the color.
  """
  @spec get_blue(color) :: float
  def get_blue(color), do: get_attribute(color, :blue)
  @doc """
    Gets the `:hue` property of the color.
  """
  @spec get_hue(color) :: float
  def get_hue(color), do: get_attribute(color, :hue)
  @doc """
    Gets the `:saturation` property of the color.
  """
  @spec get_saturation(color) :: float
  def get_saturation(color), do: get_attribute(color, :saturation)
  @doc """
    Gets the `:lightness` property of the color.
  """
  @spec get_lightness(color) :: float
  def get_lightness(color), do: get_attribute(color, :lightness)
  @doc """
    Gets the `:alpha` property of the color.
  """
  @spec get_alpha(color) :: float
  def get_alpha(color), do: get_attribute(color, :alpha)

  @doc """
    Get's any color attribute from the color.
  """
  @spec get_attribute(color, atom) :: float
  def get_attribute(color, key) do
    color
    |> cast_color_by_attribute(key)
    |> Map.fetch!(key)
  end

  # sass rgb functions
  @spec invert(color) :: rgb_color
  def invert(color) do
    rgb_color = rgb(color)
    rgb(255 - rgb_color.red, 255 - rgb_color.green, 255 - rgb_color.blue, color.alpha)
  end

  @spec mix(color, color, number) :: rgb_color
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

    alpha = get_alpha(color1) * p + get_alpha(color2) * (1 - p)
    rgb(r, g, b, alpha)
  end

  @doc """
  Adjusts any color attribute and returns the new color.

  If necessary, this will transform the color between rgb and hsl representations. Will return with a `CSSColor.HSL`
  color if adjusting `:hue`, `:saturation` or `:lightness`, a `CSSColor.RGB` color if adjusting `:red`, `:green` or
  `:blue` and the original representation if adjusting `:alpha`.

  The value_function must be a function that takes the old value and the amount provided and returns the new value.
  Simple examples include the arithmetic operators (`&+/2`, `&-/2`, `&*/2` or `&//2`).

  The final value will be capped to the valid intervals of each field (0-255 for `:red`, `:green` and `:blue`), 0-360
  for `:hue` and 0-1 for `:saturation`, `:lightness` and `:alpha`.

  ## Examples:

      iex> rgb(150, 150, 150) |> adjust(50, :blue, &+/2)
      %CssColors.RGB{alpha: 1.0, blue: 200.0, green: 150.0, red: 150.0}

      iex> rgb(150, 150, 150) |> adjust(250, :blue, &+/2)
      %CssColors.RGB{alpha: 1.0, blue: 255.0, green: 150.0, red: 150.0}

      iex> rgb(150, 150, 150) |> adjust(200, :hue, &+/2)
      %CssColors.HSL{alpha: 1.0, hue: 200.0, lightness: 0.5882352941176471,
       saturation: 0.0}

      iex> rgb(150, 150, 150) |> adjust(0, :red, fn(old, new) -> old + (new - old) / 2 end)
      %CssColors.RGB{alpha: 1.0, blue: 150.0, green: 150.0, red: 75.0}

  """
  @spec adjust(color, number, atom,  (float, number -> number)) :: color
  def adjust(struct, amount, field, value_function) do
    struct = cast_color_by_attribute(struct, field)
    new_value =
      struct
      |> Map.fetch!(field)
      |> value_function.(amount)
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
