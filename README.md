# ProdopsEx

The Elixir SDK for ProdOps

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `prodops_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:prodops_ex, "~> 0.1.0"}
  ]
end
```

[Sign up for a ProdOps account](https://app.prodops.ai) if you don't already
have one, then go to Settings -> Team -> Manage Team Details to get your API
key. If you don't see Manage Team Details, you will need to ask a ProdOps
administrator on your team for access.

Put the API key somewhere in your application configuration, such as
`dev.secret.exs`:

```
config :prodops_ex, api_key: "YOUR_API_KEY"
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/prodops_ex>.
