defmodule ProdopsExTest do
  use ExUnit.Case
  doctest ProdopsEx

  test "greets the world" do
    assert ProdopsEx.hello() == :world
  end
end
