defmodule Benchmark do
  def bench_list(i, n) do
    seq = Enum.map(1..i, fn (_) -> :rand.uniform(i) end)

    list =
      Enum.reduce(seq, EnvList.new(), fn (e, list) ->
        EnvList.add(list, e, :foo)
      end)
    seq = Enum.map(1..n, fn (_) -> :rand.uniform(i) end)

    timeraddreturn = :timer.tc(fn() ->
        Enum.each(seq, fn(e) ->
          EnvList.add(list, e, :foo)
        end)
      end)

    timerlookupreturn = :timer.tc(fn() ->
        Enum.each(seq, fn (e) ->
          EnvList.lookup(list, e)
        end)
      end)

    timerremovereturn = :timer.tc(fn() ->
        Enum.each(seq, fn(e) ->
          EnvList.remove(e, list)
        end)
      end)
      {add, _} = timeraddreturn
      {remove,_} = timerremovereturn
      {lookup,_} = timerlookupreturn
      IO.inspect(timeraddreturn)
      IO.inspect(timerremovereturn)
      IO.inspect(timerlookupreturn)
    {i, add, lookup, remove}
  end



  def bench_tree(i, n) do
    seq = Enum.map(1..i, fn (_) -> :rand.uniform(i) end)

    tree =
      Enum.reduce(seq, EnvTree.new(), fn(e, tree) ->
        EnvTree.add(tree, e, :foo)
      end)
    seq = Enum.map(1..n, fn (_) -> :rand.uniform(i) end)
    timeraddreturn = :timer.tc(fn() ->
        Enum.each(seq, fn(e) ->
          EnvTree.add(tree, e, :foo)
          :ok
        end)
      end)

    timerlookupreturn = :timer.tc(fn() ->
        Enum.each(seq, fn (e) ->
          EnvTree.lookup(tree, e)
          :ok
        end)
      end)

    timerremovereturn = :timer.tc(fn() ->
        Enum.each(seq, fn(e) ->
          EnvTree.remove(tree,e)
          :ok
        end)
      end)
    {add, :ok} = timeraddreturn
    {remove,:ok} = timerremovereturn
    {lookup,:ok} = timerlookupreturn
    IO.inspect(timeraddreturn)
    IO.inspect(timerremovereturn)
    IO.inspect(timerlookupreturn)


    {i, add, lookup, remove}
  end

  def bench_list(n) do
    ls =  [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])
    Enum.each(ls, fn (i) ->
    {i, tla, tll, tlr} = bench_list(i, n)
    :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
    end)
    end
    def bench_tree(n) do
      ls = [16,32,64]
      :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
      :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])
      Enum.each(ls, fn (i) ->
      {i, tla, tll, tlr} = bench_tree(i, n)
      :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
      end)
      end

end
