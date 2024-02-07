defmodule Reduce do
  def length(list) do
    length(list,0)
  end
  def length([_|t],len) do
    length(t,len+1)
  end
  def length([],len) do
    len
  end


  def even(list) do
    even(list,[])
  end
  def even([h|t],new_list) do
     case rem(h,2) do
      0-> even(t,new_list++[h])
      _ -> even(t,new_list)
  end
  end
  def even([],new_list) do
    new_list
  end


  def inc(list,val) do
    inc(list,val,[])
  end
  def inc([h|t],val,new_list) do
    inc(t,val,new_list++[(h+val)])

  end

  def inc([],val,new_list) do
    new_list
   end


  def sum(list) do
    sum(list,0)
  end
  def sum([h|t],result)do
    sum(t,result+h)
  end
  def sum([],result) do
    result
  end

  def dec(list,val) do
    dec(list,val,[])
  end
  def dec([h|t],val,new_list) do
    dec(t,val,new_list++[(h-val)])

  end

  def dec([],val,new_list) do
    new_list
   end

   def mul(list,val) do
    mul(list,val,[])
  end
  def mul([h|t],val,new_list) do
    mul(t,val,new_list++[(h*val)])

  end

  def mul([],val,new_list) do
    new_list
   end
  def odd(list) do
    odd(list,[])
  end
  def odd([h|t],new_list) do
     case rem(h,2) do
      1-> odd(t,new_list++[h])
      _ -> odd(t,new_list)
  end
  end
  def odd([],new_list) do
    new_list
  end

  def list_rem(list,val) do
    list_rem(list,val,[])
  end
  def list_rem([h|t],val,new_list) do
    list_rem(t,val,new_list++[rem(h,val)])

  end

  def list_rem([],val,new_list) do
    new_list
   end

  def prod(list) do
    prod(list,nil)
  end
  def prod([h|t],result)do
    case result do
      nil -> prod(t,h)
      _ -> prod(t,result*h)
    end
  end
  def prod([],result) do
    result
  end


  def div(list,val) do
    div(list,val,[])
  end
  def div([h|t],val,new_list) do
    case rem(h,val) do
      0 -> div(t,val,new_list++[h])
      _ -> div(t,val,new_list)
    end

    end

  def div([],val,new_list) do
    new_list
  end



end
