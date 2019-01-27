defmodule CssColors.Ecto.Color do
  @moduledoc """
  Custom Ecto type for representing CSS colors.

  The colors are stored as CSS colors strings in the data store. They may be any valid CSS colors. Note that you can
  not expect the stored colors to be in any specific format (rgb/hsl etc), they may be in any supported color scheme.

  If you define a max length on the data store field, make sure any possible color can fit by setting the length to at
  least 30 characters.

  ## Example:

      defmodule User do
        use Ecto.Schema

        schema "users" do
          field :favourite_color, CssColors.Ecto.Color
        end

        def changeset(struct, params) do
          struct
          |> cast(params, [:favourite_color])
        end
      end
  """
  @behaviour Ecto.Type
  def type, do: :string

  @spec cast(String.t | CssColors.color) :: {:ok, CssColors.color} | :error
  def cast(string) when is_binary(string),
    do: parse(string)
  def cast(color = %CssColors.RGB{}),
    do: {:ok, color}
  def cast(color = %CssColors.HSL{}),
    do: {:ok, color}
  def cast(_),
    do: :error

  @spec load(String.t) :: {:ok, CssColors.color}
  def load(string) when is_binary(string),
    do: parse(string)

  defp parse(string) do
    case CssColors.parse(string) do
      result = {:ok, _color} -> result
      {:error, _} -> :error
    end
  end

  @spec dump(CssColors.color) :: {:ok, String.t}
  def dump(color = %CssColors.RGB{}), do: {:ok, do_dump(color)}
  def dump(color = %CssColors.HSL{}), do: {:ok, do_dump(color)}
  def dump(_), do: :error

  defp do_dump(color) do
    round_to = 4
    to_string CssColors.adjust(color, round_to, :alpha, fn(value, round_to) -> Float.round(value, round_to) end)

  end
end
