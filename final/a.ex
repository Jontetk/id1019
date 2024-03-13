defmodule MorseCode do
  # The codes that you should decode:

  def base,
    do: ~c".- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ..."

  def rolled,
    do: ~c".... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----"

  # The decoding tree.
  #
  # The tree has the structure  {:node, char, long, short} | :nil
  #




  def tree do
    {:node, :na,
     {:node, 116,
      {:node, 109,
       {:node, 111, {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
        {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
       {:node, 103, {:node, 113, nil, nil},
        {:node, 122, {:node, :na, {:node, 44, nil, nil}, nil}, {:node, 55, nil, nil}}}},
      {:node, 110, {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
       {:node, 100, {:node, 120, nil, nil},
        {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
     {:node, 101,
      {:node, 97,
       {:node, 119, {:node, 106, {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}}, nil},
        {:node, 112, {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}}, nil}},
       {:node, 114, {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
        {:node, 108, nil, nil}}},
      {:node, 105,
       {:node, 117, {:node, 32, {:node, 50, nil, nil}, {:node, :na, nil, {:node, 63, nil, nil}}},
        {:node, 102, nil, nil}},
       {:node, 115, {:node, 118, {:node, 51, nil, nil}, nil},
        {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end
end
defmodule Morse do
  def decode(signal) do
    tree = MorseCode.tree()
    decode(signal,tree,tree)
  end
  def decode([],root,root) do
    []
  end
  def decode([],{:node,char,long,short},_) do
    [char]
  end
  def decode([?-|msg],{:node,char,long,short},root) do
    decode(msg,long,root)
  end
  def decode([?.|msg],{:node,char,long,short},root) do
    decode(msg,short,root)
  end
  def decode([?\s|msg],{:node,char,long,short},root) do
    [char|decode(msg,root,root)]
  end



  def encode(text) do
    table = encode_table(MorseCode.tree())
    encode(text,table)
  end
  def encode([],_) do []end
  def encode([char|rest],table) do
    Map.get(table,char)++[?\s]++encode(rest,table)
  end
  def encode_table(tree) do
    encode_table(tree,[],%{})
  end
  def encode_table(:nil,_,table) do table end
  def encode_table({:node,:na,long,short},code,table) do
    table = encode_table(long,[?-|code],table)
    table = encode_table(short,[?.|code],table)
  end
  def encode_table({:node,char,long,short},code,table) do
    table = Map.put(table,char,Enum.reverse(code))
    table = encode_table(long,[?-|code],table)
    table = encode_table(short,[?.|code],table)
  end
end
