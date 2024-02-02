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
  def closure(keys,env) do
    closure(keys,env,[])


  end


  def closure([hkeys|tkeys],env,cls) do
    case lookup(hkeys,env) do
      :nil -> :error
      {_,result} ->
        cls = [{hkeys,result}|cls]
        case tkeys do
          [] -> cls
          _ -> closure(tkeys,env,cls)
        end

    end
  end

def args([parh|part],[hstrs|tstrs],cls) do
  cls = [{parh,hstrs}|cls]
    case part do
      [] -> cls
      _ -> case tstrs do
        [] -> cls
        _ -> args(part,tstrs,cls)
      end
    end
end
end
