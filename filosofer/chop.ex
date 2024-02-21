

defmodule Chopstick do

def start() do
  spawn_link(fn() -> available() end)
end

def request(stick,timeout) do
  IO.inspect({self(),stick})
 send(stick,{:request,self()})
 receive do

  :granted ->
    IO.inspect({:granted,self(),stick})

    :ok
 after timeout -> :no
 end
end
def return(stick) do
  IO.inspect({:returned,self(),stick})
  send(stick,:return)
end
def quit(stick) do
  send(stick,:quit)
end


def available() do
  IO.inspect({"availabel:", self()})
  receive do
    {:request,from} ->
      IO.inspect({from,:granted,"teete"})
      send(from,:granted)
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
