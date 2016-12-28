# Issues

Fetch the `x` oldest open issues from GitHub for a given username's project

Build with

```bash
$ mix escript.build
```

Then run the generated `issues` executable providing a `user`, `project` and (optionally) a `count`, e.g. to get the 10 oldest issues for [Elixir-Lang/Elixir](https://github.com/elixir-lang/elixir) run;

```bash
$ ./issues elixir-lang elixir 10
```
