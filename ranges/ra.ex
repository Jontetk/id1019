defmodule Ranges do
  def read_string() do

    string_list =  File.read!("sample.txt")|>String.split("\n\n")
    Enum.map(string_list,fn elem ->
    t = hd(tl(String.split(elem,":")))|>String.trim()|>String.split("\n");
    Enum.map(t,fn elem ->String.split(elem," ")|>
    Enum.map(fn elem -> {num,_}= Integer.parse(elem);num; end)  end) end)

  end
  def seed([seeds|rest]) do
    seeds = hd(seeds)
    Enum.map(seeds,fn cseed -> map_resolver(cseed,rest) end)
  end
  def map_resolver(input,[map|next_map]) do
    case List.foldl(map,:nil,fn [first|[second|[third|_]]],acc ->
      case acc do
      :nil ->
        case input>=second and input <= second+third do
        true->


          first-second+input
        false ->
          acc
      end
      _ -> acc
    end
   end) do
  :nil -> map_resolver(input,next_map)
  output -> map_resolver(output,next_map)
   end
  end
  def map_resolver(input,[]) do
    input
  end

  def the_run() do
    [loch|loct] = read_string()|>seed()
    List.foldl(loct,loch,fn elem,acc -> case elem<acc do
    true -> elem

    false -> acc
     end end)
  end

end
