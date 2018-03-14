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
    assert Enum.all?(x, fn [x, y] -> x <= y end)
  end

  test "abs/1 is +ve (or zero) regardles of input's parity" do
    table = [
      {-5, 5},
      {0,  0},
      {-5, 5}]
    for {i, o} <- table do
      assert abs(i) === o
    end
  end

  describe "abs/1 is +ve (or zero) regardless of input's parity:" do
    test "output is +ve when input is -ve" do
      assert abs(-5) === +5
    end

    test "output is zero when input is zero" do
      assert abs(0) === 0
    end

    test "output is +ve when iput is +ve" do
      assert abs(+5) === +5
    end
  end

  property "abs/1 is +ve regardles of input's parity" do
    check all i <- integer(), i != 0 do
      assert abs(i) > 0
    end
  end

  property "abs/1 has same magnitude as argument" do
    check all i <- integer(), i != 0 do
      cond do
        i < 0 ->
          assert abs(i) + i === 0

        i > 0 ->
          assert abs(i) + i === 2 * i
      end
    end
  end
end
