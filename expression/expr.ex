defmodule Expressi do

def new_env(key_vals) do
  Map.new(key_vals)
end
def find_var(env,var) do
  Map.get(env,var)
end


def eval({:num, n}, _) do {:num,n} end
def eval({:var, v}, env) do {:num,find_var(env,v)} end
def eval({:q,n1,n2},_) do
  case n1/n2 do
    x when trunc(x) == x -> {:num,trunc(x)}
    _ -> case Integer.gcd(n1,n2) do
      1 -> {:q,n1,n2}
      gcdvar -> {:q,trunc(n1/gcdvar),trunc(n2/gcdvar)}

    end
  end


 end
def eval({:add, e1,e2}, env) do
  add(e1, e2,env)
end
def eval({:mul, e1,e2}, env) do
  mul(e1, e2,env)
end
def eval({:sub, e1,e2}, env) do
  sub(e1, e2,env)
end
def eval({:div, e1,e2}, env) do
  div(e1, e2,env)
end
def add(e1,e2,env) do
  case eval(e1,env) do
    {:num, n1} -> case eval(e2,env) do
      {:num,n2} -> {:num, n1+n2}
      {:q,n2,n3} -> eval({:q,n1*n3+n2,n3},env)
    end
    {:q,n1,n2} -> case eval(e2,env) do
      {:num, n3} -> eval({:q,n3*n2+n1,n2},env)
      {:q,n3,n4} -> eval({:q,n1*n4+n2*n3,n2*n4},env)
    end
  end
end


def sub(e1,e2,env) do
  case eval(e1,env) do
    {:num,n1} -> case eval(e2,env) do
      {:num,n2} -> {:num,n1-n2}
      {:q,n2,n3} -> add({:num,n1},{:q,n2*-1,n3},env)
      end
    {:q,n1,n2} -> case eval(e2,env) do
      {:num,n3} -> add({:q,n1,n2},{:num,n3*-1},env)
      {:q,n3,n4} -> add({:q,n1,n2},{:q,n3*-1,n4},env)
    end
  end
end
def mul(e1,e2,env) do
  case eval(e1,env) do
    {:num,n1} -> case eval(e2,env) do
      {:num,n2} -> {:num,n1*n2}
      {:q,n2,n3} -> eval({:q,n2*n1,n3},env)
    end
    {:q,n1,n2} -> case eval(e2,env) do
      {:num,n3} -> eval({:q,n1*n3,n2},env)
      {:q,n3,n4} -> eval({:q,n1*n3,n2*n4},env)
    end
  end
end

def div(e1,e2,env) do
  case eval(e1,env) do
    {:num,n1} -> case eval(e2,env) do
      {:num,n2} -> eval({:q,n1,n2},env)
      {:q,n2,n3} -> mul({:num,n1},{:q,n3,n2},env)
    end
    {:q,n1,n2} -> case eval(e2,env) do
      {:num,n3} -> mul({:q,n1,n2},{:q,1,n3},env)
      {:q,n3,n4} -> mul({:q,n1,n2},{:q,n4,n3},env)
    end
  end
end

end
