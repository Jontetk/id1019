defmodule Springs do

  def string_number_combiner(r2,num) do
    String.duplicate("#{r2}#{","}",num)
    |> String.trim_trailing(",")
  end
  def remove_last_question(string) do
    [_|good_string] = String.reverse(string)|>String.to_charlist()
    String.reverse("#{good_string}")
  end

  def parse_string(stringy,num) do
    String.split(stringy,"\n") |>
    Enum.map(fn str -> [r1|r2] = String.split(str, " ")
    r1 = String.duplicate("#{r1}#{"?"}",num)|> remove_last_question;
    {String.to_charlist(r1),String.split(string_number_combiner(hd(r2),num),",")|>
    Enum.map(fn element ->{num,_}= Integer.parse(element);
    num end)} end)
  end

  def check_correct([nlh|[nlth|nltt]],[dnh|dnt]) do

    case nlh do

      ?# -> case dnh do
        1 ->
          case nlth do
            ?# -> 0
            ?? -> check_correct([?#|[?.|nltt]],[dnh|dnt])
            _ -> check_correct([nlth|nltt],dnt)
          end

        _ -> case nlth do
          ?# -> check_correct([nlth|nltt],[dnh-1|dnt])
          ?? -> res = check_correct([?#|[?.|nltt]],[dnh|dnt])
          res2 = check_correct([?#|[?#|nltt]],[dnh|dnt])
          res+res2
          _ -> 0
        end
      end
      ?? -> case nlth do
      ?? -> res = check_correct([?#|[?.|nltt]],[dnh|dnt])
      res2 = check_correct([?.|[?.|nltt]],[dnh|dnt])
      res3 = check_correct([?#|[?#|nltt]],[dnh|dnt])
      res4 = check_correct([?.|[?#|nltt]],[dnh|dnt])
      res+res2+res3+res4

      _ ->
      res = check_correct([?#|[nlth|nltt]],[dnh|dnt])
      res2 = check_correct([?.|[nlth|nltt]],[dnh|dnt])
      res+res2
    end
      _ -> check_correct([nlth|nltt],[dnh|dnt])

    end
  end
  def check_correct(remaining,[]) do
    check_correct(remaining,[0])
  end

  def check_correct([h],damaged_num) do
    case length(damaged_num) do
      x when x > 1 -> 0
      _ ->  [dn] = damaged_num
      case h do
      ?# -> case dn do
        1 -> 1
        _ -> 0
      end
      ?? -> res = check_correct([?#],damaged_num)
      res2 = check_correct([?.],damaged_num)
      res+res2


      _ -> case dn do
        0 -> 1
        _ -> 0
      end
      end

    end
  end






  def dolashiet(input,num) do
    strings = parse_string(input,num)
    List.foldl(strings,0,fn elem,sum -> {string,nums} = elem; check_correct(string,nums)+sum end)
  end


end
