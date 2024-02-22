defmodule Waiter do

  def start(chops) do
    spawn_link(fn() -> waiting(chops,Map.new()) end)
  end
  def request_sticks(wfun,strength) do
    send(wfun,{:queue,self(),strength})
    receive do
      {:ok,c1,c2} ->
        {:ok,c1,c2}
      _->
        :no
    end

  end
  def return_sticks(wfun,c1,c2) do
    send(wfun,{:return,c1,c2})
  end



  def waiting(chops,phil_map) do
    receive do
      {:queue,philo,strength} ->
        phil_map = Map.put(phil_map,philo,strength)
        case length(chops) do
        x when x> 1 ->
        case List.foldl(Map.to_list(phil_map),{philo,Map.get(phil_map,philo)},fn {key,value},{mkey,mval} -> case value<mval do
          true -> {key,value}
          false->{mkey,mval}
        end

        end ) do
        {^philo,_} ->

          [c1|[c2|rchops]] = chops
          cresp = Chopstick.request(c1,c2,500)
          send(philo,{cresp,c1,c2})
          waiting(rchops,phil_map)
          _ ->

            send(philo,:no)
          waiting(chops,phil_map)
        end

          _ ->


            send(philo,:no)
          waiting(chops,phil_map)


      end
      {:return,c1,c2} ->
        Chopstick.return(c1)
        Chopstick.return(c2)
        waiting([c1|[c2|chops]],phil_map)
      {:died,phil} ->
        waiting(chops,Map.put(phil_map,phil,:infinity))

    end







  end



end
