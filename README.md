# ContentSpinner
**Basic implementation of a content-spinner**

## Installation
The package is not yet available in hex. If you need it please reach out through an issue :)

```elixir
def deps do
  [
    {:content_spinner, git:"https://github.com/nutshell-lab/content-spinner.git"}
  ]
end
```

## Getting started
```elixir
    iex> template = ["[", {:now, :iso}, "] : ", ["Hello ", "Hey "], :surname, ", here is your timestamp : ", {:now, :timestamp}]
    iex> data = %{ surname: "Jon" }
    iex> translator = fn
      :surname, passed_data -> passed_data.surname
      {:now, :iso}, _data -> DateTime.utc_now() |> DateTime.to_iso8601()
      {:now, :timestamp}, _data -> DateTime.utc_now() |> DateTime.to_unix()
    end
    iex> ContentSpinner.spin(template, data, translator)
```

## I want more
We are interested. Please [reach out]("https://github.com/nutshell-lab/content-spinner/issues") :)