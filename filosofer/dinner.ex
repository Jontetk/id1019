defmodule Dinner do
  def start(hunger,strength,bp), do: spawn(fn -> init(hunger,strength,bp) end)
  def init(hunger,strength,bp) do
  c1 = Chopstick.start()
  c2 = Chopstick.start()
  c3 = Chopstick.start()
  c4 = Chopstick.start()
  c5 = Chopstick.start()
  ctrl = self()
  chops=[c1|[c2|[c3|[c4|[c5]]]]]
  guifun = Gai.start([:arendt,:hypatia,:simone,:elisabeth,:ayn])

  wfun = Waiter.start(chops)



  Philosopher.start(hunger, :nil,:nil, :arendt, ctrl,strength,guifun,wfun)
  Philosopher.start(hunger, :nil,:nil, :hypatia, ctrl,strength,guifun,wfun)
  Philosopher.start(hunger, :nil,:nil, :simone, ctrl,strength,guifun,wfun)
  Philosopher.start(hunger, :nil,:nil, :elisabeth, ctrl,strength,guifun,wfun)
  Philosopher.start(hunger, :nil,:nil, :ayn, ctrl,strength,guifun,wfun)




  wait(5, [c1, c2, c3, c4, c5],guifun,bp,0,0)
  end
  def wait(0, chopsticks,guifun,bp,d,c) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
    Process.exit(guifun,:kill)

    send(bp,{:dinner_done,d,c})
    end
    def wait(n, chopsticks,guifun,bp,d,c) do
    receive do
    :done ->
    wait(n - 1, chopsticks,guifun,bp,d,c+1)
    :dead ->
      wait(n - 1, chopsticks,guifun,bp,d+1,c)
    :abort ->
    Process.exit(self(), :kill)
    end
    end

end
