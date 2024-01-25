defmodule EnvList do
def new() do
  []

end
def add(map,key,value) do
  case map do
    [] ->[{key,value}|map]
    _ -> add(map,key,value,[])
  end


end
def add([h|t],key,value,new_map) do

  case t do
    [] -> case h do
      {^key,_} -> new_map = new_map++[{key,value}]; new_map
      _ -> new_map = new_map++[h,{key,value}];new_map
    end

    _ -> case h do
      {^key,_} -> new_map = new_map++[{key,value}|t]; new_map
      _ ->  new_map = new_map++[h]; add(t,key,value,new_map)
    end
  end
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
