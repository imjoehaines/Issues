defmodule Issues.Cli do
  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a table
  of the last _n_ issues in a github project
  """

  @default_count 4

  def run(argv) do
    argv
     |> parse_args
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is a GitHub username, project name and
  (optionally) the number of entries to format.

  Returns a tuple of `{user, project, count}` or `:help`
  if --help (or -h) was given, or there were no arguments
  """
  def parse_args([]), do: :help

  def parse_args(argv) do
    parse = OptionParser.parse(
      argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )

    case parse do
      {[help: true], _, _}
        -> :help

      {_, [user, project, count], _}
        -> {user, project, String.to_integer(count)}

      {_, [user, project], _}
        -> {user, project, @default_count}

      _ -> :help
    end
  end
end
