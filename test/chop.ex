

defmodule Chop do

def start() do
  spawn_link(fn() -> available() end)
end

def request(chop) do
 send(chop,{:request,self()})
 receive do
  :granted -> :ok
 end
end
def return(chop) do
  send(chop,:return)
end

def available() do
  :io.format("available \n")
  receive do

    {:request,from} ->
      :io.format("req rec~w\n",[from])
      send(from,:granted)
      gone()
    :quit -> :ok
  end

end

def gone() do
  receive do
    {:return,from} -> :io.format("ret rec\n")
    send(from,:granted)
    available()
  :quit -> :ok
  end
end



end
