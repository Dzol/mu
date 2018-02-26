defmodule MuTest do
  use ExUnit.Case
  use ExUnitProperties

  test "first few fibonacci" do
    assert Mu.fibonacci(2) === 1
    assert Mu.fibonacci(3) === 2
    assert Mu.fibonacci(4) === 3
  end

  test "a longer sequence" do
    f = [0,1,1,2,3,5,8,13,21]
    for {input, output} <- Enum.zip(0..8, f) do
      assert Mu.fibonacci(input) === output
    end
  end

  property "fibonacci are positive (or zero)" do
    check all i <- integer(0..15) do
      assert Mu.fibonacci(i) >= 0
    end
  end

  test "monotonically increasing" do
    ## given
    s = for n <- 0..15, do: Mu.fibonacci(n)
    ## when
    x = Enum.chunk_every(s, 2, 1, :discard)
    ## then
    assert Enum.all?(x, &apply(fn (x, y) -> x <= y end, &1))
  end
end
