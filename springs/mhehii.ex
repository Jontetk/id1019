defmodule Springs do
  def string_number_combiner(r2,num) do
    String.duplicate("#{r2}#{","}",num)
    |> String.trim_trailing(",")
  end
  def remove_last_question(string) do
    [_|good_string] = String.reverse(string)|>String.to_charlist()
    String.reverse("#{good_string}")
  end

  def parserthingy(stringy,num) do
    String.split(stringy,"\n") |>
    Enum.map(fn str -> [r1|r2] = String.split(str, " ")
    r1 = String.duplicate("#{r1}#{"?"}",num)|> remove_last_question;
    {String.to_charlist(r1),String.split(string_number_combiner(hd(r2),num),",")|>
    Enum.map(fn element ->{num,_}= Integer.parse(element);
    num end)} end)
  end

  def dynamic_check(remaining,numbers,mem) do
    case Map.get(mem,{remaining,numbers}) do
      :nil ->
      {res,mem} = check_correct(remaining,numbers,mem)
      mem = Map.put(mem,{remaining,numbers},res)
      {res,mem}
    res ->{res,mem}
    end
  end


  def check_correct([nlh|[nlth|nltt]],[dnh|dnt],mem) do

    case nlh do

      ?# -> case dnh do
        1 ->
          case nlth do
            ?# -> {0,mem}
            ?? -> {res,mem} = dynamic_check([?#|[?.|nltt]],[dnh|dnt],mem)
            {res2,mem} = dynamic_check([?#|[?#|nltt]],[dnh|dnt],mem)
            {res+res2,mem}
            _ -> dynamic_check([nlth|nltt],dnt,mem)
          end
        0 -> case length(dnt) do
          0 -> {0,mem}
          _ -> dynamic_check([nlth|nltt],dnt,mem)
        end

        _ -> case nlth do
          ?# -> dynamic_check([nlth|nltt],[dnh-1|dnt],mem)
          ?? -> {res,mem} = dynamic_check([?#|[?.|nltt]],[dnh|dnt],mem)
          {res2,mem} = dynamic_check([?#|[?#|nltt]],[dnh|dnt],mem)
          {res+res2,mem}
          _ -> {0,mem}
        end
      end
      ?? -> case nlth do
      ?? -> {res,mem} = dynamic_check([?#|[?.|nltt]],[dnh|dnt],mem)
      {res2,mem} = dynamic_check([?.|[?.|nltt]],[dnh|dnt],mem)
      {res3,mem} = dynamic_check([?#|[?#|nltt]],[dnh|dnt],mem)
      {res4,mem} = dynamic_check([?.|[?#|nltt]],[dnh|dnt],mem)
      {res+res2+res3+res4,mem}

      _ ->
      {res,mem} = dynamic_check([?#|[nlth|nltt]],[dnh|dnt],mem)
      {res2,mem} = dynamic_check([?.|[nlth|nltt]],[dnh|dnt],mem)
      {res+res2,mem}
    end
      _ -> dynamic_check([nlth|nltt],[dnh|dnt],mem)

    end


  end
  def check_correct(remaining,[],mem) do
    dynamic_check(remaining,[0],mem)
  end

  def check_correct([h],damaged_num,mem) do
    case length(damaged_num) do
      x when x > 1 -> {0,mem}
      _ ->  [dn] = damaged_num
      case h do
      ?# -> case dn do
        1 -> {1,mem}
        _ -> {0,mem}
      end
      ?? -> {res,mem} = dynamic_check([?#],damaged_num,mem)
      {res2,mem} = dynamic_check([?.],damaged_num,mem)
      {res+res2,mem}


      _ -> case dn do
        0 -> {1,mem}
        _ -> {0,mem}
      end
      end

    end
  end



  def check_correct([],damaged_num,mem) do
    case length(damaged_num) do
      x when x > 1 -> {0,mem}
      _ ->  [dn] = damaged_num
        case dn do
          0 -> {1,mem}
          _ -> {0,mem}
        end
    end


  end


  def dolashiet(stringfuk,num) do
    stringys = parserthingy(stringfuk,num)
    List.foldl(stringys,0,fn elem,sum -> {string,nums} = elem; {res,_} = check_correct(string,nums,Map.new()); res+sum end)
  end


end
