defmodule Benchmark do
  def bench_list({n,m}) do
    {time, res} = :timer.tc(fn() ->
      Dinner.start(n,m,self())
      receive do
        {:dinner_done,d,c} -> {d,c}

      end

    end)
    {time/1,res}
    end

  def bench() do
    ls = [
      {1,2}, {1,3}, {1,4}, {1,5}, {1,8}, {1,16}, {1,32}, {1,64},
      {2,3}, {2,4}, {2,5}, {2,8}, {2,16}, {2,32}, {2,64},
      {3,4}, {3,5}, {3,8}, {3,16}, {3,32}, {3,64},
      {4,5}, {4,8}, {4,16}, {4,32}, {4,64},
      {5,8}, {5,16}, {5,32}, {5,64},
      {8,16}, {8,32}, {8,64},
      {16,32}, {16,64},
      {32,64}

  ]
    :io.format("# benchmark with ~w operations, time per operation in us\n", [1])
    :io.format("~6.s~12.s\n", ["n", "time",])
    Enum.each(ls, fn (i) ->
    {time,{d,c}} = bench_list(i)

    {h,s} = i
    IO.puts("#{h},#{s} #{time} #{d} #{c}")
    end)
    end

end
