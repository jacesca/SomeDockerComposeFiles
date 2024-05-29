# Dockerization

Docker file samples

Features:
- Docker (by default files should be named "Dockerfile")
    - Single Stage
    - Multi Stage
    - Platform
- jq command and installation for windows
- Docker compose (by default files should be named "compose.yaml")

## Docker instructions
- To start a container
```
docker run <image-name>:<image-ver>

# Interactive
docker run -it <image-name>:<image-ver>

# Detached
docker run -d <image-name>:<image-ver>

# Naming the container
docker run --name <container-name> <image-name>:<image-ver>
```

- To run a container and remove it inmediately upon exit
```
docker run --rm <image-name>:<image-ver>

# Example with an extra param
# docker run --rm alpine:latest /bin/sh
```

- To list containers (running and stopped)
```
docker ps -a
```

- To build an image
```
docker build -t <image-name>:<image-ver> -f <docker-file> .
```

- To bind - mount the host filesystem 
```
# multiple files can be replaced by using multiples -v
# path needs to be full
# ex. docker run -v C:/Users/Joe/projects/configenv.json:/home/config.json readjson

docker run -v <path-source-file>:<path-target-file> <image-name>:<image-ver>
```

- To run a container 
```
# -i for interactive
docker start -i <container-name>
```

- Full example for building containers with default config file and replacing a file
```
# Create a container
$ docker run --name readDefault readjson
>> Container created for company: DEFAULT

# Create a new version with a new config gile
$ docker run --name readNamed -v C:/projects/configenv.json:/home/config.json readjson
>> Container created for company: The File Store

# run the default container
$ docker start -i readDefault
>> Container created for company: DEFAULT

# run the modified container
$ docker start -i readNamed
>> Container created for company: The File Store
```

- Managing volumes
```
# Create a volume
docker volume create <volume-name>

# List available volumenes
docker volume ls 
docker volume list

# Provides assorted metadata about the volume
docker volume inspect <volume-name>

# Remove a volume
docker volume rm <volume-name>
```

- To list all the networks the docker engine daemon knows about.
```
docker network ls --no-trunc
```

- To expose ports
```
docker run -p <host-port>:<container-port> <image-name>:<image-ver>

# to expose container port to random host port
# then you need to use: "docker ps -a" to verify the host port
docker run -P <image-name>:<image-ver>
```

- Finding exposed ports
```
docker inspect <container-id>

#        "NetworkSettings": {
#            ...
#            "Ports": {
#                "7000/tcp": [
#                    {
#                        "HostIp": "0.0.0.0",
#                        "HostPort": "7000"
#                    }
#                ]
#            },
```

- Working with Docker networks
```
docker network ls                     # to list all docker networks on the host
docker network create <network-name>  # to create a network
docker network rm <network-name>      # to remove a network
```

## Additional documentation
- [Reducing a python (docker) image size using multi-stage](https://stackoverflow.com/questions/48543834/how-do-i-reduce-a-python-docker-image-size-using-a-multi-stage-build)
- [Docker Compose Documentation](https://docs.docker.com/compose/compose-file/)
