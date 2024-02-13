defmodule Springs do

  def parserthingy(stringy) do
    String.split(stringy,"\n") |>
    Enum.map(fn str -> [r1|r2] = String.split(str, " ");
    {String.to_charlist(r1),String.split(hd(r2),",")|>
    Enum.map(fn element ->{num,_}= Integer.parse(element);
    num end)} end)

  end

  def states([35|t],new_list,damaged_num,arra) do
    states(t,new_list++[35],damaged_num,arra)
  end
  def states([46|t],new_list,damaged_num,arra) do
    states(t,new_list++[46],damaged_num,arra)
  end
  def states([63|t],new_list,damaged_num,arra) do
    arra = states([35|t],new_list,damaged_num,arra)
    arra = states([46|t],new_list,damaged_num,arra)

    arra
  end

  def states([],new_list,damaged_num,arra) do
    b = check_correct(new_list,damaged_num)

    if(b==1) do
    end
    arra+b
  end




  def check_correct([nlh|[nlth|nltt]],[dnh|dnt]) do

    case nlh do
      35 -> case dnh do
        1 ->
          case nlth do
            35 -> 0
            _ -> check_correct([nlth|nltt],dnt)
          end
        0 -> case length(dnt) do
          0 -> 0
          _ -> check_correct([nlth|nltt],dnt)
        end
        _ -> case nlth do
          35 -> check_correct([nlth|nltt],[dnh-1|dnt])
          _ -> 0
        end



      end
      _ -> check_correct([nlth|nltt],[dnh|dnt])
    end


  end
  def check_correct(new_list,[]) do
    check_correct(new_list,[0])
  end

  def check_correct([h],damaged_num) do
    case length(damaged_num) do
      x when x > 1 -> 0
      _ ->  [dn] = damaged_num
      case h do
      35 -> case dn do
        1 -> 1
        _ -> 0
      end
      _ -> case dn do
        0 -> 1
        _ -> 0
      end
      end

    end
  end



  def check_correct([],damaged_num) do
    case length(damaged_num) do
      x when x > 1 -> 0
      _ ->  [dn] = damaged_num
        case dn do
          0 -> 1
          _ -> 0
        end
    end


  end


  def dolashiet(stringfuk) do
    stringys = parserthingy(stringfuk)
    List.foldl(stringys,0,fn elem,sum -> {string,nums} = elem; states(string,[],nums,0)+sum end)
  end


end
