defmodule Mandel do



  def process_creator(_,_,_,_,_,_,_,proc_num,0,processes) do
    {processes,proc_num}
  end

  def process_creator(width,height,trans,depth,ctrl,x,y,proc_num,num,processes) do
        process_creator(width,height,trans,depth,ctrl,x+1,y,proc_num+1,num-1,[spawn(fn () -> mandel_calc(width,height,trans,depth,ctrl,x,y,proc_num) end)|processes])
  end


  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end
    row_handler(width, height, trans, depth,[])
  end

  def row_handler(width,height,trans,depth,list) do
    ctrl = self()
    {processes,proc_num}=process_creator(width,height,trans,depth,ctrl,0,0,0,24,[])
    list = rows(width,height,trans,depth,list,0,0,proc_num,0)
    Enum.map(processes,fn process -> send(process,:quit)  end)
    list
  end
  def rows(width,height,trans,depth,[hlist|tlist],x,y,proc_num,wait_num) do
    receive do
      {:mand_done,^wait_num,res,proc} ->
        {x,y,[hlist|tlist]} = case x== width do
          true -> {0,y+1,[[]|[hlist|tlist]]}
          false -> {x,y,[hlist|tlist]}
        end
        case y == height do
          true -> tlist
          false -> send(proc,{:new_calc,x,y,proc_num}); rows(width,height,trans,depth,[hlist++[res]|tlist],x+1,y,proc_num+1,wait_num+1)
        end


    end

  end
  def rows(width,height,trans,depth,[],x,y,proc_num,wait_num) do
    receive do
      {:mand_done,^wait_num,res,proc} ->
        {x,y,list} = case x== width do
          true -> {0,y+1,[[]|[]]}
          false -> {x,y,[]}
        end
        case y == height do
          true -> list
          false -> send(proc,{:new_calc,x,y,proc_num}); rows(width,height,trans,depth,[[res]],x+1,y,proc_num+1,wait_num+1)
        end
    end
  end
  def mandel_calc(width,height,trans,depth,ctrl,x,y,proc_num) do

    res = Color.convert(Brot.mandelbrot(trans.(x,y),depth),depth)
    self = self()
    send(ctrl,{:mand_done,proc_num,res,self})
    receive do
      {:new_calc,new_x,new_y,new_proc_num} -> mandel_calc(width,height,trans,depth,ctrl,new_x,new_y,new_proc_num)
      {:quit} -> :ok
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
    PPM.write("smallpp.ppm", image)
    end

end
