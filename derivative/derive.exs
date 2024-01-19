
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
  | {:cos,expr()}
  | {:inv_mul,expr(),expr()}
  | literal()



  def test() do
  e = {:inv,{:sin,{:mul,{:num,2},{:var,:x}}}}
  d = deriv(e,:x)



  IO.write("expression: #{pprint(simplify(e))} \n")
  IO.write("result: #{pprint(d)} \n")
  IO.write("simplified: #{pprint(simplify(d))} \n")


  end





  def simplify({:add, e1, e2}), do: simplify_add(simplify(e1),simplify(e2))
  def simplify({:mul, e1, e2}), do: simplify_mul(simplify(e1),simplify(e2))
  def simplify({:exp,e1,e2}), do: simplify_exp(simplify(e1),simplify(e2))
  def simplify({:inv,e}), do: simplify_inv(e)
  def simplify({:inv_mul,e1,e2}), do: simplify_inv_mul(e1,e2)
  def simplify({:ln,e}), do: simplify_ln(e)
  def simplify({:sqrt,e}), do: simplify_sqrt(e)
  def simplify({:sin,e}), do: simplify_sin(e)
  def simplify({:cos,e}), do: simplify_cos(e)


  def simplify(e), do: e

  def simplify_add({:num ,0}, e2), do: e2
  def simplify_add(e1,{:num ,0}), do: e1
  def simplify_add({:num,n1},{:num,n2}), do: {:num,n1+n2}
  def simplify_add(e1,e2), do: {:add,e1,e2}

  def simplify_mul({:num ,0}, _), do: {:num,0}
  def simplify_mul(_,{:num ,0}), do: {:num,0}
  def simplify_mul({:inv,e1},e2), do: {:inv_mul,e1,e2}
  def simplify_mul(e2,{:inv,e1}), do: {:inv_mul,e1,e2}
  def simplify_mul({:num ,1}, e2), do: e2
  def simplify_mul(e1,{:num ,1}), do: e1
  def simplify_mul({:num ,1}, e2), do: e2
  def simplify_mul(e1,{:num ,1}), do: e1
  def simplify_mul({:num,n1},{:num,n2}), do: {:num,n1*n2}
  def simplify_mul(e1,e2), do: {:mul,e1,e2}

  def simplify_exp({:num ,0}, {:num, n}) do
  case n do
    x when x> 0 -> {:num, 0}
    _ -> {:exp,{:num,0},{:num,n}}
  end
  end

  def simplify_exp({:num,n},{:num ,0}) do
    case n do
      x when x> 0 -> {:num,1}
      x when x< 0 -> {:num,-1}
      _ -> {:exp,{:num,n},{:num,0}}
    end
  end
  def simplify_exp({:num ,1}, _), do: {:num,1}
  def simplify_exp(e1,{:num ,1}), do: e1
  def simplify_exp({:num,n1},{:num,n2}), do: {:num,n1**n2}
  def simplify_exp(e1,e2), do: {:exp,e1,e2}

  def simplify_inv({:num,0}), do: {:inv,{:num,0}}
  def simplify_inv({:num,n}), do: {:num,1/n}
  def simplify_inv(e), do: {:inv,e}

  def simplify_inv_mul({:num,0},e), do: {:inv_mul,{:num,0},e}
  def simplify_inv_mul({:num,n1},{:num,n2}), do: {:num,n2/n1}
  def simplify_inv_mul(e1,e2), do: {:inv_mul,e1,e2}

  def simplify_ln({:num,n}), do: {:num,:math.log2(n)}
  def simplify_ln(e), do: {:ln,e}

  def simplify_sqrt({:num,n}), do: {:num,:math.sqrt(n)}
  def simplify_sqrt(e), do: {:sqrt,e}

  def simplify_sin({:num,n}), do: {:num,:math.sin(n)}
  def simplify_sin(e), do: {:sin,e}

  def simplify_cos({:num,n}), do: {:num,:math.cos(n)}
  def simplify_cos(e), do: {:cos,e}




  def deriv({:num, _}, _), do: {:num,0}

  def deriv({:var, v}, v), do: {:num,1}

  def deriv({:var, _}, _), do: {:num,0}

  def deriv({:mul, e1, e2}, v), do: {:add,{:mul,deriv(e1,v),e2},{:mul,e1,deriv(e2,v)}}

  def deriv({:add, e1, e2}, v), do: {:add, deriv(e1,v),deriv(e2,v)}

  def deriv({:exp,e,{:num,n}},v), do: {:mul,{:mul,{:num,n},
  {:exp,e,{:num,n-1}}},deriv(e,v)}

  def deriv({:inv,e},v), do: {:mul,{:mul,{:num,-1},{:inv,
  {:exp,e,{:num,2}}}},deriv(e,v)}

  def deriv({:ln,e},v), do: {:mul,{:inv,e},deriv(e,v)}

  def deriv({:sqrt,e},v), do: {:mul,{:mul,{:inv,{:sqrt,e}},{:num,0.5}},deriv(e,v)}

  def deriv({:sin,e},v), do: {:mul,{:cos,e},deriv(e,v)}

  def deriv({:cos,e},v), do: {:mul,{:mul,{:sin,e},{:num,-1}},deriv(e,v)}

  def pprint({:num,n}), do:  "#{n}"

  def pprint({:var,v}), do: "#{v}"

  def pprint({:add,e1,e2}), do: "(#{pprint(e1)}+#{pprint(e2)})"

  def pprint({:mul,e1,e2}), do: "#{pprint(e1)}*#{pprint(e2)}"

  def pprint({:exp,e1,e2}), do: "#{pprint(e1)}^(#{pprint(e2)})"

  def pprint({:inv,e1}), do: "1/(#{pprint(e1)})"

  def pprint({:inv_mul,e1,e2}), do: "(#{pprint(e2)})/(#{pprint(e1)})"

  def pprint({:ln,e1}), do: "ln(#{pprint(e1)})"

  def pprint({:sqrt,e1}), do: "sqrt(#{pprint(e1)})"

  def pprint({:sin,e1}), do: "sin(#{pprint(e1)})"

  def pprint({:cos,e1}), do: "cos(#{pprint(e1)})"
end
