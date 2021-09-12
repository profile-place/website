# profile.place
> **Website backend for [profile.place](https://profile.place), written in Elixir**

## Development
### Requirements
- Elixir
- MongoDB
- Redis

### Process (Locally)
- [Fork](https://github.com/profile-place/website/fork) the repository
- Clone the forked repository
- Start a terminal session in the directory and run `mix deps.get` to get the elixir dependencies
  - If you get a weird Make error on Windows, make sure Make is installed properly
- Before you run **profile.place**, you must run the following commands to add environment variabels to your instance:
  - Unix: `for /F %A in (.env) do SET %A && iex -S mix phx.server`
  - Windows: `export $(cat .env | xargs) && iex -S mix phx.server`
- Run `mix phx.server` or `iex -S mix phx.server` if you want the iex session
- Open the tab [here](http://localhost:4000)

### Process (Docker)
:sparkles: ***coming soon™️*** :sparkles:

### Configuration
Check `config/config.exs` for the environment variables you need to set

## Maintainers
- [ravy](https://ravy.pink) (Project management and being cute)
- [August](https://floofy.dev) (Frontend)
- [Cyber](https://github.com/Cyber28) (Backend)

## License
**profile.place** is released under the **GPL-3** License, read [here](/LICENSE) for more information!
