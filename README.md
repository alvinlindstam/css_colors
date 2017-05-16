# CssColors

Library for parsing, writing and manipulation (css) colors.

## Installation

Add  [css_colors](https://hex.pm/packages/css_colors) to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:css_colors, "~> 0.1.0"}]
end
```

## Documentation

See the [full documentation on HexDocs](https://hexdocs.pm/css_colors/CssColors.html).

## Examples

```elixir
iex> "#123456" |> parse |> lighten(0.2) |> to_string
"hsl(210, 65%, 40%)"

iex> to_string mix(parse("#f00"), parse("#00f"), 0.25)
"#4000BF"
```
