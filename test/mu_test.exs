defmodule MuTest do
  use ExUnit.Case
  use ExUnitProperties

  test "first few fibonacci" do
    assert Mu.fibonacci(2) === 1
    assert Mu.fibonacci(3) === 2
    assert Mu.fibonacci(4) === 3
  end

  test "a longer sequence" do
    f = [0, 1, 1, 2, 3, 5, 8, 13, 21]

    for {input, output} <- Enum.zip(0..8, f) do
      assert Mu.fibonacci(input) === output
    end
  end

  test "abs/1 is positive (or zero) regardless of input's parity" do
    table = [{-3,3}, {0,0}, {+5,5}]
    for {input, output} <- table do
      assert abs(input) === output
    end
  end

  property "abs/1 is positive (or zero) regardless of input's parity" do
    check all i <- integer() do
      assert abs(0 + i) === abs(0 - i) ## +/-i
    end
    check all i <- integer() do
      assert abs(i) >= 0
    end
  end

  # defp negative_integer do
  #   map(positive_integer(), & -1 * &1)
  # end

  # property "abs/1 has the same magnitude as input" do
  #   check all i <- negative_integer() do
  #     assert abs(i) + i === 0
  #   end
  # end

  property "abs/1 has the same magnitude as input" do
    check all i <- integer() do
      assert square(abs(i)) === square(i)
    end
  end

  defp square x do
    Kernel.round(:math.pow(x, 2))
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

  test "fibonacci/1 tends toward the Golden Ratio phi/0" do
    x = 1..32
    |> Enum.map(&Mu.fibonacci/1) ## [1, 1, 2, 3, 5, ...]
    |> Enum.chunk_every(2, 1, :discard) ## [[1, 1], [1, 2], [2, 3], ...]
    |> Enum.map(fn [smaller, bigger] -> bigger / smaller end) ## [1/1, 2/1, 3/2, ...]
    |> Enum.map(& Kernel.abs(phi() - &1)) ## [0.61, 0.38, 0.11, ...]
    |> Enum.chunk_every(2, 1, :discard) ## [[0.61, 0.38], [0.38, 0.11], [0.11, 0.04], ...]
    assert decreasing?(x)
  end

  test "abs/1 is +ve (or zero) regardles of input's parity" do
    table = [{-5, 5}, {0, 0}, {+5, 5}]

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
      x = abs(i) + i; assert x === 0 or x === 2 * i
    end

    check all i <- integer(), i != 0 do
      cond do
        i < 0 ->
          assert abs(i) + i === 0

        i > 0 ->
          assert abs(i) + i === 2 * i
      end
    end
  end

  property "integer/1 bound by run size" do

    x = 100; Application.put_env(:stream_data, :max_runs, x)

    check all i <- integer() do
      assert i >= -x
      assert i <= x
    end

    y = 3_210; Application.put_env(:stream_data, :max_runs, y)

    check all i <- integer() do
      assert i >= -y
      assert i <= y
    end

    check all l <- list_of(integer(), min_length: 1) do
      assert Enum.min(l) >= -y
      assert Enum.max(l) <= y
    end
  end

  defp phi do
    x = 1 + :math.sqrt(5); x / 2
  end

  defp decreasing? x do
    f = fn [x, y] ->
      x > y
    end
    Enum.all?(x, f)
  end
end
