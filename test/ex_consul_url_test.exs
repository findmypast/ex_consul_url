defmodule ExConsulUrlTest do
  use ExUnit.Case
  doctest ExConsulUrl

  describe "ExConsulUrl.url_for/2" do
    test "Consul call returns data with first address and port" do
      assert ExConsulUrl.url_for("test", "test", ExConsulUrl.MockHTTPClient) == "127.0.0.1:12345"
    end

    test "Address and port correspond to requested tag" do
      assert ExConsulUrl.url_for("test", "integration", ExConsulUrl.MockHTTPClient) == "127.0.0.1:54321"
    end

    test "Non existant service results in an empty string" do
      assert ExConsulUrl.url_for("non-existant", "integration", ExConsulUrl.MockHTTPClient) == ""
    end
  end

  describe "ExConsulUrl.url_for!/2" do
    test "Consul call returns data with first address and port" do
      assert ExConsulUrl.url_for!("test", "test", ExConsulUrl.MockHTTPClient) == "127.0.0.1:12345"
    end

    test "Address and port correspond to requested tag" do
      assert ExConsulUrl.url_for!("test", "integration", ExConsulUrl.MockHTTPClient) == "127.0.0.1:54321"
    end

    test "Non existant service results in an exception being thrown" do
      assert_raise ExConsulUrl.ServiceNotFound, "Service not found", fn ->
        ExConsulUrl.url_for!("non-existant", "integration", ExConsulUrl.MockHTTPClient)
      end
    end
  end
end
