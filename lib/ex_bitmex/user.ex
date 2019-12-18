defmodule ExBitmex.User do
  @type t :: %ExBitmex.User{}

  defstruct ~w(
    id
    owner_id
    firstname
    lastname
    username
    email
    phone
    created
    last_updated
    preferences
    tfa_enabled
    affiliate_id
    pgp_pub_key
    country
    geoip_country
    geoip_region
    typ
  )a
end
