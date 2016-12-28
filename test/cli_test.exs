defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.Cli, only: [parse_args: 1]

  test "the 'help' flag is returned when there are no arguments" do
    assert parse_args([]) == :help
  end

  test "the 'help' flag is parsed from '--help'" do
    assert parse_args(["--help", "anything"]) == :help
  end

  test "the 'help' flag is parsed from '-h'" do
    assert parse_args(["-h", "anything"]) == :help
  end

  test "three values are returned if three are given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count uses default if two values are given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
end
