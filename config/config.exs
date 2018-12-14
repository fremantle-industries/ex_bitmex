use Mix.Config

config :ex_bitmex, domain: "testnet.bitmex.com"

config :exvcr,
  filter_request_headers: [
    "api-key",
    "api-nonce",
    "api-signature"
  ],
  filter_sensitive_data: []
