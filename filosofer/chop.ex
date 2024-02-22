

defmodule Chopstick do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

def start() do
  spawn_link(fn() -> available() end)
end

def request(stick1,stick2,timeout) do
 send(stick1,{:request,self()})
 send(stick2,{:request,self()})
 receive do

  {:granted,^stick1} ->
    receive do
      {:granted,^stick2} ->
        :ok
      after timeout ->
        Chopstick.return(stick1)
         :no
    end
  {:granted,^stick2} ->
    receive do
      {:granted,^stick1} ->
        :ok
      after timeout ->
        Chopstick.return(stick2)
         :no
    end


 after timeout -> :no
 end
end
def return(stick) do
  send(stick,:return)
end
def quit(stick) do
  send(stick,:quit)
end


def available() do
  receive do
    {:request,from} ->
      send(from,{:granted,self()})
      gone()
    :quit -> :ok
  end

end

def gone() do
  receive do
    :return ->
    available()
  :quit -> :ok
  end
end


end
