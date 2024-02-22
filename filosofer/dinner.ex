defmodule Dinner do
  def start(), do: spawn(fn -> init() end)
  def init() do
  c1 = Chopstick.start()
  c2 = Chopstick.start()
  c3 = Chopstick.start()
  c4 = Chopstick.start()
  c5 = Chopstick.start()
  ctrl = self()
  chops=[c1|[c2|[c3|[c4|[c5]]]]]
  IO.inspect(chops)
  guifun = Gai.start([:arendt,:hypatia,:simone,:elisabeth,:ayn])

  wfun = Waiter.start(chops)



  Philosopher.start(5, :nil,:nil, :arendt, ctrl,8,guifun,wfun)
  Philosopher.start(5, :nil,:nil, :hypatia, ctrl,8,guifun,wfun)
  Philosopher.start(5, :nil,:nil, :simone, ctrl,8,guifun,wfun)
  Philosopher.start(5, :nil,:nil, :elisabeth, ctrl,8,guifun,wfun)
  Philosopher.start(5, :nil,:nil, :ayn, ctrl,8,guifun,wfun)




  wait(5, [c1, c2, c3, c4, c5],guifun)
  end
  def wait(0, chopsticks,guifun) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
    Process.exit(guifun,:kill)
    end
    def wait(n, chopsticks,guifun) do
    receive do
    :done ->
    wait(n - 1, chopsticks,guifun)
    :abort ->
    Process.exit(self(), :kill)
    end
    end

end
