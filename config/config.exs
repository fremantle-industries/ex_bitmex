use Mix.Config

config :exvcr,
  filter_request_headers: [
    "api-key",
    "api-nonce",
    "api-signature"
  ],
  filter_sensitive_data: []
