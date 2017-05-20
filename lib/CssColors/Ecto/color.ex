defmodule CssColors.Ecto.Color do
  @moduledoc """
  Custom Ecto type for representing CSS colors.
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
  def dump(color = %CssColors.RGB{}), do: {:ok, to_string(color)}
  def dump(color = %CssColors.HSL{}), do: {:ok, to_string(color)}
  def dump(_), do: :error
end
