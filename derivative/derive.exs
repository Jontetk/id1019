
defmodule Derive do



@type literal() :: {:num, number()}
  | {:var, atom()}

@type expr() :: {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp,expr(),literal()}
  | {:inv,expr()}
  | {:ln,expr()}
  | {:sqrt,expr()}
  | {:sin,expr()}
  | literal()



  def test() do
  e = {:sqrt,{:add,{:mul,{:num,2},{:exp,{:var,:x},{:num,2}}},{:num,1}}}
  deriv(e,:x)

  end




  def deriv({:num, _}, _), do: {:num,0}

  def deriv({:var, v}, v), do: {:num,1}

  def deriv({:var, _}, _), do: {:num,0}

  def deriv({:mul, e1, e2}, v), do: {:add,{:mul,deriv(e1,v),e2},{:mul,e1,deriv(e2,v)}}

  def deriv({:add, e1, e2}, v), do: {:add, deriv(e1,v),deriv(e2,v)}

  def deriv({:exp,e,{:num,n}},v), do: {:mul,{:mul,{:num,n},{:exp,e,{:num,n-1}}},deriv(e,v)}

  def deriv({:inv,e},v), do: {:mul,{:mul,{:num,-1},{:inv,{:exp,{e,{:num,2}}}}},deriv(e,v)}

  def deriv({:ln,e},v), do: {:mul,{:inv,e},deriv(e,v)}

  def deriv({:sqrt,e},v), do: {:mul,{:mul,{:inv,{:sqrt,e}},{:num,0.5}},deriv(e,v)}

  def deriv()

end
