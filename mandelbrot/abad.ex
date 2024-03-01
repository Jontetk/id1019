

defmodule Mandel do
  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end
    rows(width, height, trans, depth, [[Color.convert(Brot.mandelbrot(trans.(0,0),depth),depth)]],1,0)
  end


  def rows(width,height,trans,depth,[hlist|tlist],x,y) do
    case x == width do
      true ->rows(width,height,trans,depth,[[]|[hlist|tlist]],0,y+1)
      false-> case y == height do
         true->tlist
          false-> rows(width,height,trans,depth,[hlist++[Color.convert(Brot.mandelbrot(trans.(x,y),depth),depth)]|tlist],x+1,y)
      end
    end
  end
  def demo() do
    :timer.tc(fn()->small(-2.6,2.5, 2.5)end)
    end
    def small(x0, y0, xn) do
      width = 1000
      height = 1000
    depth = 500
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small.ppm", image)
    end

end
