defmodule Phil do

  @eating 200
  @dreaming 100
  @delat 4

  def start(name,left,right,hunger) do
    spawn_link(fn() -> dreaming(name,left,right,hunger,strength)end)
  end
  def dreaming(name,_,_,0) do
    :io.format("~w is done and happy\n",[name])
    :ok
  end
  def dreaming(name,left,right,hunger) do
    :io.format("~w is selep\n",[name])
    sleep(@dreaming)
    :io.format("~w is wake\n",[name])
    waiting(name,left,right,hunger)
  end
  def waiting(name,left,right,hunger) do
    :io.format("~w is wait\n",[name])
    Chop.request(right)
    case
    wait or dream
    sleep(@delay)
    Chop.request(left)
    eating(name,left,right,hunger)
  end

  def eating(name,left,right,hunger) do
    :io.format("~w is eat\n",[name])
    sleep(@eating)
    Chop.return(left)
    Chop.return(right)
    dreaming(name,left,right,hunger-1)
  end

end
