defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end


  def start(hunger,right,left,name,ctrl,strength,guifun) do
    spawn_link(fn() ->IO.inspect({name,self()}); dreaming(hunger,right,left,name,ctrl,strength,guifun) end)
  end
  def dreaming(0,_,_,name,ctrl,_,guifun) do
    IO.puts("#{name} is done and happy")
    send(guifun,{:action, name, :done})
    send(ctrl,:done)
  end
  def dreaming(hunger,right,left,name,ctrl,strength,guifun) do
    IO.puts("#{name} is dream,#{hunger}")
    send(guifun,{:action, name, :leave})
    sleep(20)
    waiting(hunger,right,left,name,ctrl,strength,guifun)
  end
  def waiting(hunger,right,left,name,ctrl,strength,guifun) do
    IO.puts("#{name} is wait,#{hunger}")
    send(guifun,{:action, name, :waiting})
    case Chopstick.request(left,1000) do
      :no ->
      case strength-1 do
        0 -> no_longer_able_to_dream(hunger,right,left,name,ctrl,strength,guifun)
        stren -> dreaming(hunger,right,left,name,ctrl,stren,guifun)
        end

      _ -> got_left_chop(hunger,right,left,name,ctrl,strength,guifun)
    end



  end

  def got_left_chop(hunger,right,left,name,ctrl,strength,guifun) do
  sleep(70)
    case Chopstick.request(right,1000) do # timeout could be done per phil as arg aswell
      :no -> Chopstick.return(left)
       case strength-1 do
      0 -> no_longer_able_to_dream(hunger,right,left,name,ctrl,strength,guifun)
      stren -> dreaming(hunger,right,left,name,ctrl,stren,guifun)
      end
    _ -> eating(hunger,right,left,name,ctrl,strength,guifun)
  end
  end

  def eating(hunger,right,left,name,ctrl,strength,guifun) do
    IO.puts("#{name} is eat,#{hunger}")
    send(guifun,{:action, name, :enter})
    sleep(100)
    Chopstick.return(left)
    Chopstick.return(right)
    dreaming(hunger-1,right,left,name,ctrl,strength,guifun)
  end


  def no_longer_able_to_dream(_,_,_,name,ctrl,_,guifun) do
    IO.puts("#{name} has eaten their final meal")
    send(guifun,{:action,name,:died})
    send(ctrl,:done)
  end
end
