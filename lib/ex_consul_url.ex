defmodule ExConsulUrl do

  @moduledoc """
  Provides a functionality to retrieve service urls from Consul.
  """

  @doc """

  Get an IP and port as a string from Consul based on a service name and tag(s).
  If multiple IP and ports are available, the first one is picked. This call uses the Consul `catalog/service` API.

  ## Parameters
    - service_name: The name of the service as it appears in Consul.
    - tags: The tag of the service. Comma seprated if there are multiple tags.

  ## Examples
    ```elixir
    > ExConsulUrl.url_for("my-service", "production")
    "127.0.0.1:8080"
    ```
  """

  def url_for(service_name, tags, http_client \\ HTTPoison) do

    consul_host = Application.get_env(:ex_consul_url, :consul_host)
    url = construct_consul_url(service_name, tags, consul_host)

    response =
      case http_client.get!(url) do
        %{body: body} -> Poison.decode!(body)
      end
      |> List.first

    case response do
      nil -> ""
      response -> "#{response |> Map.get("ServiceAddress")}:#{response |> Map.get("ServicePort")}"
    end

  end

  defp construct_consul_url(service_name, tags, consul_host) do
    "#{consul_host}/v1/catalog/service/#{service_name}?tag=#{tags}"
  end

end
