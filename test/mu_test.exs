defmodule MuTest do
  use ExUnit.Case

  test "first few fibonacci" do
    import Mu, only: [fibonacci: 1]

    assert fibonacci(2) === 1
    assert fibonacci(3) === 2
    assert fibonacci(4) === 3
  end

  test "a longer sequence" do
    import Mu, only: [fibonacci: 1]

    f = [0,1,1,2,3,5,8,13,21]
    for {input, output} <- Enum.zip(0..8, f) do
      assert fibonacci(input) === output
    end
  end
end
