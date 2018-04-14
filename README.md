# Interrogator

## Running it

After cloning the repository:

``` shell
$ git submodule update --init
$ mix do deps.get, deps.compile, compile
$ iex -S mix phx.server
```

To see catalogue data manually:

``` elixir
Interrogator.Catalogue.SourceFile.list()
|> List.last # or whatever
|> Interrogator.Catalogue.SourceFile.read!
```
