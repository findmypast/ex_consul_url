defmodule ExConsulUrl do

  @http_client Application.get_env(:ex_consul_url, :http_client) || HTTPoison

  defmodule ServiceNotFound do
    defexception message: "Service not found"
  end

  defmodule InvalidConsulUri do
    defexception message: "The consul uri is malformed"
  end

  @moduledoc """
  Provides functionality to retrieve service urls from Consul.
  """

  @doc """

  Get an IP and port as a string from Consul based on a service name and tag(s).
  If multiple IP and ports are available, the first one is picked. This call uses the Consul `catalog/service` API.

  ## Parameters
    - service_name: The name of the service as it appears in Consul.
    - tags: The tag of the service. Comma seprated if there are multiple tags.

  ## Examples
    ```
    ExConsulUrl.url_for("my-service", "production")
    127.0.0.1:8080

    ExConsulUrl.url_for("consul://production.my-service")
    http://127.0.0.1:8080
    ```
  """

  def url_for(service_name, tags) do

    case _url_for(service_name, tags) do
      {:error ,_} -> ""
      {:ok, {ip, port}} -> "#{ip}:#{port}"
    end

  end

  @doc """
  Hard failure version of ExConsulUrl.url_for/2. Throws ServiceNotFound error.
  """

  def url_for!(service_name, tags) do

    case url_for(service_name, tags) do
      "" -> raise ServiceNotFound
      result -> result
    end

  end

  @doc """

  Given a uri with a `consul` scheme, convert the url to contian the IP and port instead.
  This follows the following uri format: `consul://tag.service-name`.
  *Note: only single tags are supported for now*

  ## Parameters
    - service_uri: The uri of a service, must have `consul://` scheme.

  ## Examples
    ```
    ExConsulUrl.url_for("consul://production.my-service")
    http://127.0.0.1:8080
    ```
  """
  def url_for(service_url) do

    uri = URI.parse(service_url)

    with %URI{scheme: "consul"} <- uri,
          {:ok, mapped_uri} <- map_host_from_consul(uri)
    do
      mapped_uri |> URI.to_string
    else
      %URI{scheme: _ } -> {:error, "Missing consul:// scheme"}
      error -> error
    end

  end

  defp _url_for(service_name, tags) do

    response = consul_request(service_name, tags)
    case response do
      nil -> {:error, "Service not found"}
      response -> {:ok, {response |> Map.get("ServiceAddress"), response |> Map.get("ServicePort")}}
    end

  end

  defp map_host_from_consul(uri) do
    host_tokens = uri.host
    |> String.split(".")

    case _url_for(host_tokens |> Enum.at(1), host_tokens |> List.first) do
      {:ok, {ip, port}} -> {:ok, %URI{uri | authority: nil, host: ip, port: port, scheme: "http"}}
      {:error, message} -> {:error, message}
    end

  end

  defp consul_request(service_name, tags) do
    consul_host = Application.get_env(:ex_consul_url, :consul_host)
    url = construct_consul_url(service_name, tags, consul_host)

    case @http_client.get!(url) do
      %{body: body} -> Poison.decode!(body)
    end
    |> List.first
  end

  defp construct_consul_url(service_name, tags, consul_host) do
    "#{consul_host}/v1/catalog/service/#{service_name}?tag=#{tags}"
  end

end
