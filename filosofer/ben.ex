defmodule Benchmark do
  def bench_list({n,m,dtime}) do
    {time, res} = :timer.tc(fn() ->
      Dinner.start(n,m,self(),dtime)
      receive do
        {:dinner_done,d,c} -> {d,c}

      end

    end)
    {time/1000,res}
    end

  def bench() do
    ls = [
      {10,1,100},{10,4,100},{10,8,100},{10,16,100},{10,32,100},
      {10,1,250},{10,4,250},{10,8,250},{10,16,250},{10,32,250},
  ]
    :io.format("# benchmark with ~w operations, time per operation in us\n", [1])
    :io.format("~6.s~12.s\n", ["n", "time",])
    Enum.each(ls, fn (i) ->
    {time,{d,c}} = bench_list(i)

    {h,s,dt} = i
    IO.puts("#{h},#{s},#{dt} #{time} #{d} #{c}")
    end)
    end

end
