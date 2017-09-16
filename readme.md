
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

### Publish docker image for production



## Deployment

### Set up

To run production server as a service, run following command to install `table-api.service`.

```
table-api$ sh ./scripts/install-service.sh
```

And then, set to use production config file.

```
table-web$ cp configs.production.env configs.env
```

### Release a specific version

To release a specific version of the client based on Git tag, follow the steps below.

#### Build for release

Pull the version `{version}` from the Git server and build the client with the following command.

```
table-web$ docker-compose run web yarn run release {version}
```

#### Deploy the client

After successfully build the desired version of the source code to a client,
run following command to put the built app in `table-web/deploy`, and then restart the server to apply.

```
table-web$ sh ./scripts/deploy.sh
```
