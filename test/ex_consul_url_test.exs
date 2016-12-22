defmodule ExConsulUrlTest do
  use ExUnit.Case
  doctest ExConsulUrl

  describe "ExConsulUrl.url_for/2" do
    test "Consul call returns data with first address and port" do
      assert ExConsulUrl.url_for("test", "test") == "127.0.0.1:12345"
    end

    test "Address and port correspond to requested tag" do
      assert ExConsulUrl.url_for("test", "integration") == "127.0.0.1:54321"
    end

    test "Non existant service results in an empty string" do
      assert ExConsulUrl.url_for("non-existant", "integration") == ""
    end
  end

  describe "ExConsulUrl.url_for!/2" do
    test "Consul call returns data with first address and port" do
      assert ExConsulUrl.url_for!("test", "test") == "127.0.0.1:12345"
    end

    test "Address and port correspond to requested tag" do
      assert ExConsulUrl.url_for!("test", "integration") == "127.0.0.1:54321"
    end

    test "Non existant service results in an exception being thrown" do
      assert_raise ExConsulUrl.ServiceNotFound, "Service not found", fn ->
        ExConsulUrl.url_for!("non-existant", "integration")
      end
    end
  end

  describe "ExConsulUrl.url_for/1" do
    test "Host part of the consul uri is converted to IP and port with http scheme" do
      assert ExConsulUrl.url_for("consul://integration.test") == "http://127.0.0.1:54321"
    end

    test "Non existant service results in an error tuple" do
      assert ExConsulUrl.url_for("consul://integration.non-existant") == {:error, "Service not found"}
    end
  end
end
