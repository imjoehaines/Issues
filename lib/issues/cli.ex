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
     |> process
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

  def process(:help) do
    IO.puts """
    Issues
    Fetch the oldest <count> issues from GitHub for a <username>/<project>

    usage: issues <user> <project> [count | #{@default_count}]
    """

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_ascending_order
    |> Enum.take(count)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({_, error}) do
    {_, message} = List.keyfind(error, "message", 0)

    IO.puts "Error fetching from GitHub #{message}"
    System.halt(2)
  end

  def sort_into_ascending_order(issues) do
    Enum.sort(
      issues,
      fn (a, b) -> Map.get(a, "created_at") <= Map.get(b, "created_at") end
    )
  end
end
