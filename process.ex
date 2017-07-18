defmodule Mix.Tasks.ProcessFile do
  alias Experimental.Flow

  @shortdoc "ingests file"
  def run do
    start = DateTime.utc_now |> DateTime.to_unix

    "./files/2014.txt"
    |> File.stream!(:line)
    |> Flow.from_enumerable()
    |> Flow.map(fn(line) -> process(line) end)
    |> Flow.partition()
    |> Flow.filter(fn(x) -> x.amount > 100_000 end)
    |> Enum.count
    |> IO.inspect

    fin = DateTime.utc_now |> DateTime.to_unix
    IO.puts(fin - start)
  end

  def process(line) do
    last_name  = String.slice(line, 0..39) |> String.trim
    first_name = String.slice(line, 40..69) |> String.trim

    address_1  = String.slice(line, 70..99) |> String.trim
    address_2  = String.slice(line, 100..129) |> String.trim
    address_3  = String.slice(line, 130..159) |> String.trim
    city       = String.slice(line, 160..189) |> String.trim
    state      = String.slice(line, 190..191) |> String.trim
    zip        = String.slice(line, 192..200) |> String.trim

    tax_id     = String.slice(line, 201..209) |> String.trim
    amount     = String.slice(line, 248..257) |> String.trim |> process_amount

    holder_contact     = String.slice(line, 280..319) |> String.trim
    holder_address_1   = String.slice(line, 320..349) |> String.trim
    holder_city        = String.slice(line, 410..439) |> String.trim
    holder_state       = String.slice(line, 440..441) |> String.trim
    holder_zip         = String.slice(line, 442..450) |> String.trim

    %{
      last_name: last_name,
      first_name: first_name,
      address_1: address_1,
      address_2: address_2,
      address_3: address_3,
      city: city,
      state: state,
      zip: zip,
      tax_id: tax_id,
      amount: amount,

      holder_contact: holder_contact,
      holder_address_1: holder_address_1,
      holder_city: holder_city,
      holder_state: holder_state,
      holder_zip: holder_zip,
    }
  end

  def process_amount(""),  do: 0
  def process_amount(num), do: num |> String.to_integer
end
