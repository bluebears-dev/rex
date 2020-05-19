# Rex - The distributed rendering platform supervisor 
![Elixir CI](https://github.com/baymax42/rex/workflows/Elixir%20CI/badge.svg?branch=master) [![Coverage Status](https://coveralls.io/repos/github/baymax42/rex/badge.svg?branch=master&service=github)](https://coveralls.io/github/baymax42/rex?branch=master) [![codebeat badge](https://codebeat.co/badges/604d4a5f-35dd-48cf-b0b7-f0afc1fb13b3)](https://codebeat.co/projects/github-com-baymax42-rex-master)

## What is it?
**Rex** is a web service functioning as the passive rendering supervisor. It just manages connected nodes and reacts to their requests appropriately. Currently, it supports only one client, which is Blender (by using a dedicated add-on which will be released in the future).

The project was part of the [Bachelor's thesis](https://www.overleaf.com/read/bdjzzvyqsrrx) on how to improve rendering times by using the distributed network.

## Features

In current state it only handles animation projects (there is a plan to extend this to scenes and more complex configurations).

Everything is managed through Blender plug-in, including starting rendering project. This is a subject to change, as Blender plug-in is highly inconvenient and hard to maintain.

As for now, client can:
* start a project,
* join the network,
* send the rendered fragment,
* ask for next task.

Rex can also restore its state after restart - right now this is partially made and it will be extended.

Rex uses *Phoenix Channels* to handle most of node communication. Sometimes direct *HTTP* call is used, for example sending a project to the supervisor.

## About project structure

Rex uses umbrella project structure and it contains two main modules: `Rex` and `RexWeb`. 

### Module `Rex`

`Rex` is used as a data module and it provides access to the database. 

### Module `RexWeb`

`RexWeb` handles all the communication. You can find definitions of endpoints and channels inside the aforementioned module.

#### Endpoints

To view the available endpoints you can use:
```bash-
mix phx.routes RexWeb.Router
```

Documentation of these endpoints will be provided in the future along with other changes. 

## Developer environment
### How to set up the project?

If you would like to run the very-alpha version of the **Rex**, you would need:
* [Elixir](https://elixir-lang.org/install.html) (at least 1.9.4),
* [docker](https://docs.docker.com/get-docker/)
* [docker-compose](https://docs.docker.com/compose/install/).

Both `docker` and `docker-compose` are used to start the PostgreSQL database, which is used to provide persistence for the supervisor. 
You can also start your database locally and just tweak the values in the `.env` file.

After having dependencies installed, you need to do a few simple steps before starting it up:
* Create `.env` file using provided `.env.example`,
* Run mix `deps.get` inside the root project directory,
* Start the database by running `docker-compose up -d`.

Then you can start the web service by issuing the `mix phx.server` and it will be available on the `localhost:4000`.

### What is the recommended tooling?

I prefer the `VS Code` as the main editor along with these plugins for Elixir dev:
* ElixirLinter,
* ElixirLS Fork: Elixir support and debugger,
* hex.pm IntelliSense.

The project also uses `dialyxir` and the `credo` for linting and formatting purposes.
