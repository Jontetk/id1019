defmodule Reduceepic do







  def map(list, func) do
    map(list,func,[])

  end
  def map([h|t],func,new_list) do
    map(t,func,new_list++[func.(h)])


  end
  def map([],_,new_list) do
    new_list
  end

  def reducel([h|t],init_val,func) do
    reducel(t,func.(h,init_val),func)

  end
  def reducel([],init_val,_) do
    init_val
  end
  def reducer([h|t],init_val,func) do
    func.(h,reducer(t,init_val,func))

  end
  def reducer([],init_val,_) do
    init_val
  end

  def filterl(list,func) do
    filterl(list,func,[])
  end
  def filterl([h|t],func,new_list) do
    case func.(h) do
      true -> filterl(t,func,new_list++[h])
      false -> filterl(t,func,new_list)
    end
  end
  def filterl([],func,new_list) do
    new_list
  end

  def filterlalt(list,func) do
    filterlalt(list,func,[])
  end
  def filterlalt([h|t],func,new_list) do
    case func.(h) do
      true -> filterlalt(t,func,[h|new_list])
      false -> filterlalt(t,func,new_list)
    end
  end
  def filterlalt([],func,new_list) do
    new_list
  end


  def filterr([h|t],func) do
    case func.(h) do
      true -> [h|filterr(t,func)]
      false -> filterr(t,func)
    end
  end
  def filterr([],func) do
    []
  end


  def length(list) do
    reducel(list,0,fn _, count -> count+1 end)
  end



  def even(list) do
    filterl(list,fn item -> case rem(item,2) do
      0-> true
      _ -> false end end)
  end



  def inc(list,val) do
    map(list,fn item ->item+val end)
  end



  def sum(list) do
    reducel(list,0,fn item,total ->total+item end)
  end


  def dec(list,val) do
    map(list,fn item ->item-val end)
  end


   def mul(list,val) do
    map(list,fn item ->item*val end)
  end

  def odd(list) do
    filterl(list,fn item -> case rem(item,2) do
      1-> true
      _ -> false end end)
  end


  def list_rem(list,val) do
    map(list,fn item ->rem(item,val) end)
  end


  def prod(list) do
    reducel(list,nil,fn item,total -> case total do
      nil -> item
      _ -> item*total
    end end)
  end


  def div(list,val) do
    filterl(list,fn item -> case rem(item,val) do
      0-> true
      _ -> false end end)
  end

 def sum_square_less_than_n(list,n) do
   filterl(list,fn item -> item <n end)|>
   map(fn item -> item**2 end) |>
   reducel(0,fn item,total ->total+item end)
 end





end
