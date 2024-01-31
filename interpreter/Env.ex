defmodule Env do
  def new() do
    Map.to_list(Map.new())
  end
  def add(id,str,env) do
    new_env = case env do
      %{} -> env
      _-> Map.new(env)
    end
    Map.to_list(Map.put(new_env,id,str))
  end



  def lookup(id,env) do
    new_env = case env do
      %{} -> env
      _-> Map.new(env)
    end
    result = Map.get(new_env,id)
    case result do
      :nil -> :nil
    _ ->{id,result}

    end

  end
  def remove(ids,env) do
    new_env = case env do
      %{} -> env
      _-> Map.new(env)
    end

    Map.to_list(Map.drop(new_env,ids))
  end


end
