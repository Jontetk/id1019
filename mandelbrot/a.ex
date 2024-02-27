defmodule Cmplx do
  def new(r,i) do
    {:cmplx,r,i}
  end
  def add({:cmplx,ar,ai},{:cmplx,br,bi}) do
    {:cmplx,ar+br,ai+bi}
  end
  def sqr({:cmplx,r,i}) do
    {:cmplx,r*r-i*i,r*i+r*i}
  end
  def abs({:cmplx,r,i}) do
    :math.sqrt((r**2+i**2))
  end
end
defmodule Brot do
  def mandelbrot(c, m) do
    z0 = Cmplx.new(0,0)
    i = 0
    test(i, z0, c, m)
    end

  def test(i,z,c,m) do

    case m > i do
    true ->  case Cmplx.abs(z) do
        x when x>2 -> i
        _ -> test(i+1,Cmplx.add(Cmplx.sqr(z),c),c,m)
      end
    _ -> 0
    end
  end
end
