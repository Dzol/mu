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

  defmodule ProductPalindrome do
    def go do
      for x <- 999..100, y <- 999..x do
         x * y
      end
      |> Enum.filter(&palindrome?/1)
      |> Enum.sort(& &1 >= &2)
      |> Kernel.hd()
    end

    defp palindrome? x do
      Integer.to_string(x) === String.reverse(Integer.to_string(x))
    end
  end
end
