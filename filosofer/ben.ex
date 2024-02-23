defmodule Benchmark do
  def bench_list({n,m,dtime}) do
    {time, res} = :timer.tc(fn() ->
      Dinner.start(n,m,self(),dtime)
      receive do
        {:dinner_done,d,c} -> {d,c}

      end

    end)
    {time/1,res}
    end

  def bench() do
    ls = [
      {10,1,100},{10,4,100},{10,8,100},{10,16,100},{10,32,100},
      {10,1,200},{10,4,200},{10,8,200},{10,16,200},{10,32,200},
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
