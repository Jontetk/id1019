defmodule Huffman do
  def sample do
    ~c"the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off"
  end

  def text() do
    ~c"this is something that we should encode"
  end

  def read(file) do
    text = File.read!(file)
    chars = String.to_charlist(text)
    {:ok, chars, String.length(text), Kernel.byte_size(text)}
    end


  def test do
    {:ok,sample2,strlen,bytesiz} = read("kallocain.txt")
    sample = sample2
    {tree_time,tree} = :timer.tc(fn ->tree(sample) end)
    {enc_time,encode} = :timer.tc(fn ->encode_table(tree) end)
    #decode = decode_table(tree)
    text = sample2
    {seq_time,seq} = :timer.tc(fn ->encode(text, encode) end)
    {dec_time,dec} = :timer.tc(fn ->decode(seq, encode) end)
    {dec_alt_time,dec_alt} = :timer.tc(fn ->decode_alt(seq, tree) end)
    IO.inspect({strlen,bytesiz})
    IO.inspect({length(seq),length(encode),:erlang.external_size(seq)})
    IO.inspect("#{dec_alt}")
    IO.inspect(sample2)
    IO.inspect({tree_time,enc_time,seq_time,dec_time,dec_alt_time})
    :ok
  end

  def tree(sample) do
    frequ =
      Enum.sort(Map.to_list(freq(sample)), fn {_, v1}, {_, v2} -> v2 > v1 end)
      |> Enum.map(fn {c, f} -> {c, {:f, f}} end)

    huffman(frequ)
  end

  def freq(sample) do
    freq(sample, Map.new())
  end

  def freq([], frequ) do
    frequ
  end

  def freq([char | rest], frequ) do
    frequ =
      case Map.get(frequ, char) do
        nil -> Map.put(frequ, char, 1)
        value -> Map.put(frequ, char, value + 1)
      end

    freq(rest, frequ)
  end

  def huffman(frequ) do
    huffman_tree(frequ)
  end

  def huffman_tree([{c1, {:f, f1}}, {c2, {:f, f2}} | rest]) do
    huffman_tree(insert_into({{c1, c2}, {:f, f1 + f2}}, rest, []))
  end

  def huffman_tree([{c1, {:f, f2}} | rest]) do

    c1
  end
  def huffman_tree([]) do
    []
  end

  def insert_into({c, {:f, f}}, [{c3, {:f, f3}} | rest], new_list) do
    case f < f3 do
      true -> new_list ++ [{c, {:f, f}}, {c3, {:f, f3}} | rest]
      false -> insert_into({c, {:f, f}}, rest, new_list ++ [{c3, {:f, f3}}])
    end
  end

  def insert_into({c, {:f, f}}, [], new_list) do
    new_list ++ [{c, {:f, f}}]
  end

  def encode_table(tree) do
    collect_chars(tree, [], [])
  end

  def collect_chars({left, right}, charlist, path) do
    charlist = collect_chars(left, charlist, path ++ [0])
    charlist = collect_chars(right, charlist, path ++ [1])
    charlist
  end

  def collect_chars(char, charlist, path) do
    case path do
    [] -> [{char,[1]}]
    _ ->[{char, path} | charlist]
    end
  end

  #def decode_table(tree) do
  #  # To implement...
  #end

  def encode(text, table) do
    table = Map.new(table)
    encode_char(text, table, [])
  end

  def encode_char([char | rest], table, encoded) do
    case Map.get(table, char) do
      nil -> IO.puts("Char not found in table #{char}"); encode_char(rest, table, encoded)
      char_encode -> encode_char(rest, table, [Enum.reverse(char_encode)|encoded])
    end
  end

  def encode_char([], _, encoded) do
    Enum.reverse(List.flatten(encoded))

  end

  def decode([], _) do
    []
  end

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)

    case List.keyfind(table, code, 1) do

      :nil ->
        decode_char(seq, n+1, table)

      {char,_} ->
        {char,rest}

    end
  end
  def decode_alt(seq,tree) do
    decode_alt(seq,tree,tree,[])
  end
  def decode_alt([path|rest],current,tree,charlist) do
    case current do
    {left,right} -> case path do
      0 -> decode_alt(rest,left,tree,charlist)
      1-> decode_alt(rest,right,tree,charlist)
    end
    _ -> decode_alt([path|rest],tree,tree,[current|charlist])
    end
  end
  def decode_alt([],current,_,charlist) do
    Enum.reverse([current|charlist])
  end
end
