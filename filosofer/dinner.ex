defmodule Dinner do
  def start(), do: spawn(fn -> init() end)
  def init() do
  c1 = Chopstick.start()
  c2 = Chopstick.start()
  c3 = Chopstick.start()
  c4 = Chopstick.start()
  c5 = Chopstick.start()
  ctrl = self()
  IO.inspect({c1,"c1"})
  IO.inspect({c2,"c2"})
  IO.inspect({c3,"c3"})
  IO.inspect({c4,"c4"})
  IO.inspect({c5,"c5"})

  guifun = Gai.start([:arendt,:hypatia,:simone,:elisabeth,:ayn])
  Philosopher.start(5, c1, c2, :arendt, ctrl,5,guifun)
  Philosopher.start(5, c2, c3, :hypatia, ctrl,5,guifun)
  Philosopher.start(5, c3, c4, :simone, ctrl,5,guifun)
  Philosopher.start(5, c4, c5, :elisabeth, ctrl,5,guifun)
  Philosopher.start(5, c5, c1, :ayn, ctrl,5,guifun)
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
