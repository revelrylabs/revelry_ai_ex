defmodule ProdopsEx.Config do
  @moduledoc """
  Defines the configuration structure for interacting with the ProdOps API.
  """

  @definition [
    api_url: [
      type: :string,
      default: "https://app.prodops.ai"
    ],
    api_key: [
      type: :string,
      required: true
    ],
    http_options: [
      type: :keyword_list,
      keys: [*: [type: :any]],
      default: [
        recv_timeout: 60_000
      ],
      required: false
    ]
  ]

  @schema NimbleOptions.new!(@definition)

  @doc """
  Return configuration based on passed-in, application, and default
  values combined.

  ## Precedence

  Configuration is applied with the following precendence (highest to
  lowest):
   - configuration passed into this function
   - application configuration (i.e. via config files)
   - default configuration

  Usually you do not need to use this function directly, it is already
  used by methods in this library.
  """
  @spec resolve_config(Keyword.t()) :: Keyword.t()
  def resolve_config(passed_in_config) do
    application_config = Application.get_all_env(:prodops_ex)

    passed_in_http_options = passed_in_config[:http_options] || []
    application_http_options = application_config[:http_options] || []
    default_http_options = @definition[:http_options][:default]

    http_options =
      Keyword.new()
      |> Keyword.merge(default_http_options)
      |> Keyword.merge(application_http_options)
      |> Keyword.merge(passed_in_http_options)

    resolved_config =
      Keyword.new()
      |> Keyword.merge(application_config)
      |> Keyword.merge(passed_in_config)
      |> Keyword.put(:http_options, http_options)

    NimbleOptions.validate!(resolved_config, @schema)
  end
end
