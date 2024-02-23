defmodule Philosopher do

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end


  def start(hunger,right,left,name,ctrl,strength,guifun,wfun,dtime) do
    spawn_link(fn() -> dreaming(hunger,right,left,name,ctrl,strength,guifun,wfun,dtime) end)
  end
  def dreaming(0,_,_,name,ctrl,_,guifun,wfun,dtime) do
    #IO.puts("#{name} is done and happy")
    send(guifun,{:action, name, :done})
    send(ctrl,:done)
    send(wfun,{:died,self()})
    :timer.sleep(:infinity)
  end
  def dreaming(hunger,right,left,name,ctrl,strength,guifun,wfun,dtime) do
    #IO.puts("#{name} is dream,#{hunger}")
    send(guifun,{:action, name, :leave})
    sleep(dtime)
    waiting(hunger,right,left,name,ctrl,strength,guifun,wfun,dtime)
  end
  def waiting(hunger,right,left,name,ctrl,strength,guifun,wfun,dtime) do
    #IO.puts("#{name} is wait,#{hunger}")
    send(guifun,{:action, name, :waiting})
    case Waiter.request_sticks(wfun,strength) do
      :no ->
      case strength-1 do
        0 -> no_longer_able_to_dream(hunger,right,left,name,ctrl,strength,guifun,wfun,dtime)
        new_strength -> dreaming(hunger,right,left,name,ctrl,new_strength,guifun,wfun,dtime)
        end

      {:ok,c1,c2} -> eating(hunger,c1,c2,name,ctrl,strength,guifun,wfun,dtime)
    end



  end



  def eating(hunger,right,left,name,ctrl,strength,guifun,wfun,dtime) do
    #IO.puts("#{name} is eat,#{hunger}")
    send(guifun,{:action, name, :enter})
    sleep(200)
    Waiter.return_sticks(wfun,right,left)
    dreaming(hunger-1,right,left,name,ctrl,strength,guifun,wfun,dtime)
  end




  def no_longer_able_to_dream(_,_,_,name,ctrl,_,guifun,wfun,dtime) do
    #IO.puts("#{name} has eaten their final meal")
    send(guifun,{:action,name,:died})
    send(ctrl,:dead)
    send(wfun,{:died,self()})
    :timer.sleep(:infinity)
  end
end
