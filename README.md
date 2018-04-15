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

## GraphQL

The GraphQL API is available at `/api/graphql`.

GraphiQL Playground is mounted at `/api/graphiql`.

### Example

Showing all Chaos units whose name includes the word "Spawn,"
as provided by any catalogues that were sources (at least partially)
from a codex, and also showing the catalogue name and related books:

``` graphql
query {
  catalogues(filter: {name: "chaos", bookType: CODEX}) {
    name
    books {
      name
      type
    }
    units(filter: {name: "spawn"}) {
      name
    }
  }
}
```
