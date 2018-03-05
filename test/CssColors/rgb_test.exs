defmodule CssColors.RGB.Test do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  alias CssColors.{RGB}

  test_with_params "to_string", fn(expected_string, struct) ->
    assert expected_string == to_string(struct)
  end do
    [
      {"#000000", %RGB{red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0}},
      {"#0A0F10", %RGB{red: 10.0, green: 15.0, blue: 16.0, alpha: 1.0}},
      {"#1120FF", %RGB{red: 17.0, green: 32.0, blue: 255.0, alpha: 1.0}},
      {"#010F11", %RGB{red: 0.5, green: 15.45, blue: 16.9, alpha: 1.0}},
      {"rgba(17, 32, 255, 0.33)", %RGB{red: 17.0, green: 32.0, blue: 255.0, alpha: 0.33}},
    ]
  end
end
