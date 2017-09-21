
# table-api

This is a Rails 5 powered API server for Table app.

This app is dockerized for both development and production environment.

## Development

### Set up

You need [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/install/)
version 2 or higher installed on your system.

Build Docker image for development with the command below.

```
table-api$ docker-compose build
```

After building the Docker image, copy example config files and edit them to change configurations.

```
table-api$ cp configs.examples.env configs.env
```

### Run development server

Use Rails server to see your version of code served live on the local environment.
Use docker-compose to update all dependencies and start up the server.

```
table-api$ docker-compose up
```

### Migrate database for development environment

If you need to migrate your database for development environment,
run the command below.

```
table-api$ docker-compose run app rake db:migrate
```

### Publish for production

If you want to publish the current status of the project for production release, run the command below with the `[version]` in a form of `v[0-9\.]+`.

```
table-api$ ./run publish [version]
```

To publish the project, your current branch must be `master` and
every local changes in your project should have been
committed and synced with the remote repository.

This command will result in tagging a version on a remote repository and building and pushing a docker image for this version.

## Deployment

### Set up

To run production server as a service, run following command to install `table-api.service`.

```
table-api$ ./run install-service
```

And then, set to use production config file.

```
table-web$ cp configs.production.env configs.env
```

You also need to provide required SSL certificates in `table-api/cert` directory.

### Release a specific version

To release a specific version of the client based on Git tag, run following command.

```
table-api$ ./run release [version]
```

This command will reset your code to the commit,
checkout requested version from remote repository,
pull docker image, migrate the database, and re-run the production server.

### Run database interactive console

To run an interactive console for PostgreSQL database, run a following command.

```
table-web$ ./run psql
```

This requires `psql` installed on your environment.

### Backup database


To backup production database, run a following command.

```
table-web$ ./run backup-database > ./backup/170921.sql
```

This requires `pg_dump` installed on your environment.
