# ExConsulUrl

Simple client to retrieve the IP and port that a service is running on from [HashiCorp's Consul](https://www.consul.io/).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `ex_consul_url` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ex_consul_url, "~> 0.1.0"}]
end
```

  2. Ensure `ex_consul_url` is started before your application:

```elixir
def application do
  [applications: [:ex_consul_url]]
end
```

## Usage

Given a service and it's Consul tags, retrieve the IP and port it runs on. For example:

```elixir
iex> ExConsulUrl.url_for("my-service", "production")
"127.0.0.1:8080"

iex> ExConsulUrl.url_for!("service-not-there", "production")
# Throws ServiceNotFound error
```

Note: If the service and tags map to multiple IP/port pairs, the **first** one is always chosen.
