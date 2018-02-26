defmodule Mu do
  def fibonacci(x) do
    cond do
      x === 0 ->
        x
      x === 1 ->
        x
      true ->
        fibonacci(x - 1) + fibonacci(x - 2)
    end
  end
end
