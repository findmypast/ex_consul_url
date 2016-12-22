defmodule ExConsulUrl.MockHTTPClient do

  def get!(url) do

    cond do
      url |> String.contains?("service/non-existant") ->
        %{ body: "[]" }
      url |> String.contains?("tag=integration") ->
        %{
          body:
          """
            [{
                "Node": "host1",
                "Address": "127.0.0.1",
                "ServiceID": "testService:80",
                "ServiceName": "testService",
                "ServiceTags": [
                  "integration"
                  ],
                "ServiceAddress": "127.0.0.1",
                "ServicePort": 54321
              }]
              """
            }
      true ->
        %{
          body:
          """
            [{
                "Node": "host1",
                "Address": "127.0.0.1",
                "ServiceID": "testService:80",
                "ServiceName": "testService",
                "ServiceTags": [
                  "production"
                  ],
                "ServiceAddress": "127.0.0.1",
                "ServicePort": 12345
              },
              {
                "Node": "host2",
                "Address": "127.0.0.1",
                "ServiceID": "testService:80",
                "ServiceName": "testService",
                "ServiceTags": [
                  "production"
                  ],
                "ServiceAddress": "127.0.0.1",
                "ServicePort": 12345
              }]
              """
            }
    end
  end

end
