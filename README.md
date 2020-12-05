# profile.place
> **Frontend and API monorepo for [profile.place](https://profile.place), made in Elixir**

## Installation
### Requirements
- Elixir/Erlang
- NMake
- MongoDB v3 or v4
- Redis v5+

### Process (Locally)
- [Fork](https://github.com/profile-place/website/fork) the repository
- Clone the repository (**`git clone https://github.com/$USER/website`**, replace `$USER` with your username)
- Move to the directory and run `mix deps.get` to get the dependency cache
  - If you get a nmake error, make sure you set the `MAKE` environment variable!
- Run `iex -S mix phx.server`
- Open the tab [here](http://localhost:4000)

### Process (Docker)
:sparkles: ***coming soon?*** :sparkles:

### Configuration
- Create a `config/secret.exs` file
- Add the following code, and fill the values
```elixir
import Config

config :profile_place,
  db_url:
```

## Maintainers
- [Cyber28](https://github.com/Cyber28)
- [August](https://augu.dev)
- [ravy](https://ravy.pink)

## License
**profile.place** is released under the **GPL-3** License, read [here](/LICENSE) for more information!
