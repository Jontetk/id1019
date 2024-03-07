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

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, encode)
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
    {chars, {:f, _}} = hd([{c1, {:f, f2}} | rest])
    chars
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
    [{char, path} | charlist]
  end

  def decode_table(tree) do
    # To implement...
  end

  def encode(text, table) do
    table = Map.new(table)
    encode_char(text, table, [])
  end

  def encode_char([char | rest], table, encoded) do
    case Map.get(table, char) do
      nil -> IO.puts("Char not found in table#{char}")
      char_encode -> encode_char(rest, table, encoded ++ char_encode)
    end
  end

  def encode_char([], table, encoded) do
    encoded
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
        IO.inspect("chaer")
        IO.inspect(char)
        IO.inspect(rest)
        {char,rest}

    end
  end
end
