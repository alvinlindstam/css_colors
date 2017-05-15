defmodule CssColors.HSL do
  defstruct [
    hue:        0.0, # 0-360 (degrees)
    saturation: 0.0, # 0-1 (percent)
    lightness:  0.0, # 0-1 (percent)
    alpha:      1.0  # 0-1 (percent)
  ]

  def to_string(%__MODULE__{hue: h, saturation: s, lightness: l, alpha: 1.0}) do
    "hsl(#{round(h)}, #{round(s*100)}%, #{round(l*100)}%)"
  end
  def to_string(%__MODULE__{hue: h, saturation: s, lightness: l, alpha: a}) do
    "hsla(#{round(h)}, #{round(s*100)}%, #{round(l*100)}%, #{a})"
  end

  def hsl(hue, saturation, lightness, alpha\\1.0)  do
    %__MODULE__{
      hue: cast(hue, :hue),
      saturation: cast(saturation, :saturation),
      lightness: cast(lightness, :lightness),
      alpha: cast(alpha, :alpha)
    }
  end

  def to_rgba(%__MODULE__{hue: h, saturation: s, lightness: l, alpha: a}) do
    h = h/360
    m2 = if l <= 0.5,
      do: l * (s + 1),
      else: l + s - l * s
    m1 = l * 2 - m2
    r = hue_to_rgb(m1, m2, h + 1 / 3)
    g = hue_to_rgb(m1, m2, h    )
    b = hue_to_rgb(m1, m2, h - 1 / 3)
    {r*255, g*255, b*255, a}
  end

  defp hue_to_rgb(m1, m2, h) do
    h = if h < 0, do: h + 1, else: h
    h = if h > 1, do: h - 1, else: h
    case h do
      h when h * 6 < 1 -> m1 + (m2 - m1 ) * h * 6
      h when h * 2 < 1 -> m2
      h when h * 3 < 2 -> m1 + (m2 - m1 ) * ( 2 / 3 - h) * 6
      _ -> m1
    end
  end

  def cast(hue, :hue) when hue < 0, do: cast(hue + 360, :hue)
  def cast(hue, :hue) when hue >= 360, do: cast(hue - 360, :hue)
  def cast(hue, :hue), do: hue/1
  def cast(value, field) when field in [:saturation, :lightness, :alpha] do
    value/1
    |> min(1.0)
    |> max(0.0)
  end
end

defimpl String.Chars, for: CssColors.HSL do
  def to_string(struct) do
    CssColors.HSL.to_string(struct)
  end
end


