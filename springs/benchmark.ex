defmodule Benchmark do
  def bench_list(n) do

    string_to_time = "?????????? 3,2,1"
    {time, _} = :timer.tc(fn() ->
      Springs.dolashiet(string_to_time,n)
    end)
    time/1
    end

  def bench(n) do
    ls =  [1,2,3,4,5,8,16,32,64,128]
    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s\n", ["n", "time",])
    Enum.each(ls, fn (i) ->
    time = bench_list(i)
    :io.format("~6.w~12.2f\n", [i, time])
    end)
    end

end
