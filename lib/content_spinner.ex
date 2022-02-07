defmodule ContentSpinner do
  @doc """
  Translate a template into a fully generated text.

  ## Template
  template should be a list of elements. Each element can be :
  * a string
  * a list of phrases
  * a tuple representing a specific translation

  ### A string
  A string will just be put in place without any fancy processing.

  ### A list of phrases
  One of the phrases will be randomly put in place.

  ### A tuple representing a specific translation
  A specific translator will be used along side the `data` parameter to process this tuple. You
  are expected to pass a string-returning function as a `translator` which will pattern match on the tuple.

  ## Example

    iex> template = ["[", {:now, :iso}, "] : ", ["Hello ", "Hey "], :surname, ", here is your timestamp : ", {:now, :timestamp}]
    iex> data = %{ surname: "Jon" }
    iex> translator = fn
      :surname, passed_data -> passed_data.surname
      {:now, :iso}, _data -> DateTime.utc_now() |> DateTime.to_iso8601()
      {:now, :timestamp}, _data -> DateTime.utc_now() |> DateTime.to_unix()
    end
    iex> ContentSpinner.spin(template, data, translator)
  """
  def spin(template), do: spin(template, %{}, & &1)

  def spin(template, data \\ %{}, translators) when is_list(template) do
    template
    |> Enum.scan(template, fn
      custom_term, _out when is_atom(custom_term) -> translators.(custom_term, data)
      custom_term = {_term, _param}, _out -> translators.(custom_term, data)
      list, _out when is_list(list) -> Enum.take_random(list, 1) |> hd
      string, _out when is_binary(string) -> string
      _, _ -> raise "Invalid term in content spinning template"
    end)
    |> Enum.join()
  end
end
