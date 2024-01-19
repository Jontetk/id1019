defmodule Testmodulea do



def testfun() do
  n = 1

  case n do
    x when x>=0 -> 9999

    x when x<0 -> 1

  end
end
end
