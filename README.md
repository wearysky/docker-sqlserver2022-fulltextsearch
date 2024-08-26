# SQL Server 2022 with Full-Text Search

This repository contains a Dockerfile for building a SQL Server 2022 image with full-text search enabled. The image is based on the official Microsoft SQL Server 2022 image and includes additional steps to install the full-text search feature.

## Parameters

The Dockerfile supports the following environment variables:

- **`SA_PASSWORD`**: The password for the SQL Server `sa` user. This is a required parameter.
- **`SSID_PID`**: The SQL Server edition or product ID. Defaults to `Developer`.

### Important: Password Requirements

The `SA_PASSWORD` must meet the default SQL Server 2022 strong password requirements. If the password does not meet these requirements, the container will fail to start, and the logs will display the following error:

```
ERROR: Unable to set system administrator password: Password validation failed. The password does not meet SQL Server password policy requirements because it is not complex enough
```

#### The password must meet the following criteria:

- Be at least 8 characters long.
- Contain characters from at least three of the following four sets:
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Base 10 digits (0-9)
  - Symbols (e.g., !, $, #, %)

## Building the Image

You can build the Docker image using the provided Dockerfile with the following command:

```
docker build -f sqlserver-fulltext.Dockerfile -t [name[:tag]] .
```

ie
```
docker build -f sqlserver-fulltext.Dockerfile -t myimagename:1.0 .
```

`name` is required, `tag` is optional. If tag is omitted, docker will default to "latest"

## Running the Container

To run the container, you must provide the `SA_PASSWORD` environment variable and map the port `1433` to your host machine to connect to the SQL Server instance. Use the name and tag values chosen in the build command

### Sample Docker Run Command

```
docker run -e SA_PASSWORD=YourStrong(!)Passw0rd -p 1433:1433 -d [name[:tag]]
```

- **`-e SA_PASSWORD=YourStrong(!)Passw0rd`**: Sets the `sa` user password.
- **`-p 1433:1433`**: Maps the SQL Server port to the host machine.

### Sample `docker-compose.yml`

Below is a sample `docker-compose.yml` file that builds and runs the SQL Server container:

```yaml
services:
  sqlserver:
    build:
      dockerfile: sqlserver-fulltext.Dockerfile
    container_name: sqlserver2022
    environment:
      - SA_PASSWORD=YourStrong(!)Passw0rd
      - SSID_PID=Developer
    ports:
      - "1433:1433"
    volumes:
      - sql_data:/var/opt/mssql

volumes:
  sql_data:
```

### Explanation:

- **`volumes`**: The `sql_data` volume is optional but useful if you want to persist your SQL Server data across container restarts or have access to the data files. If you don’t need persistence, you can omit the `volumes` section.
- **`ports`**: Mapping port `1433` is necessary if you want to connect to the SQL Server instance from outside the container (e.g., from SQL Server Management Studio or an application).

## Connecting to SQL Server

To connect to the SQL Server instance, use your preferred SQL client and connect to `localhost:1433` with the `sa` user and the password you specified.
