defmodule EnvList do
def new() do
  []

end
def add(map,key,value) do
  [{key,value}|map]

end
def lookup([h|t],key) do
  case h do
    {^key,_} -> h
    _ -> case t do
      [] -> :nil
      _ -> lookup(t,key)
    end

  end


end
def remove(key,map) do
  remove(key,map,new())


end
def remove(key,[h|t],new_map) do
  case t do
  [] -> case h do
    {^key,_} -> new_map
    _ -> new_map = new_map++[h];new_map
  end
  _ -> case h do
    {^key,_} -> remove(key,t,new_map)
    _ ->  new_map = new_map++[h]; remove(key,t,new_map)
  end

  end

end


end
