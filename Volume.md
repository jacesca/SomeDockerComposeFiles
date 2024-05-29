# Volumes
Giving a practical example of how to use volumes in Dockers

Let’s see how volumes work. You can start a container with a volume by setting the -v flag when you call docker run.

The following command starts a new Ubuntu 22.04 container and attaches your terminal to it (-it), ready to run demonstration commands in the following steps. A volume called demo_volume is mounted to /data inside the container. Run the command now:
```
$ docker run -it -v demo_volume:/data ubuntu:22.04
```

List the contents of your container’s /data directory:
```
$ ls /data
```

The path exists, indicating the volume has mounted successfully, but no files have been created yet. Add a test file with some arbitrary content:
```
$ echo "foobar" > /data/foo

$ cat /data/foo
foobar
```

Next, detach from your container by pressing Ctrl+C or running exit:
```
$ exit
```

Now, start a new container that attaches the same volume:
```
$ docker run -it -v demo_volume:/app alpine:latest
```

The demo_volume volume already exists so Docker will reuse it instead of creating a new one. This time, the volume is mounted to a different path inside the container, but when you list the path’s content, you’ll see the file that the first container created:
```
$ cat /app/foo
foobar
```

# Manually Creating and Linking Volumes
You can manually create volumes ahead of time with the docker volume create command:
```
$ docker volume create app_data
app_data
```

The volume can then be mounted to your containers in the same way as before:
```
$ docker run -it -v app_data:/app alpine:latest
```

# Mounting Volumes as Read-Only
Volumes are mounted in read-write mode by default. To mount a volume in read-only mode, include ro or readonly as the third field in your docker run command’s -v flag:
```
$ docker run -it -v app_data:/app:ro alpine:latest
```

The container will be able to read the volume’s content from the mount point but will be prevented from making modifications. This is ideal when a volume’s shared between multiple containers, only some of which are expected to perform writes. Write operations in containers with a readonly mount will fail with an error:
```
$ echo "foo" > /app/bar
/bin/sh: can't create /app/bar: Read-only file system
```

# Reusing Volumes When Containers Start
Sometimes you might want to start a new container with the same volumes as an existing container on your host. Instead of repeating the list of -v flags required, you can use --volumes-from to automatically include another container’s volumes:

- Create the first container
```
$ docker run -d --name db -v app_data:/data database-image:latest
```

- Create the second container
```
$ docker run -d --name backup --volumes-from db backup-image:latest
```

Docker will mount all the volumes that are already attached to the existing container. The same destination paths will be used to mount the volumes into your new container. This feature is useful when you’re backing up an existing container’s volumes. You can easily mount a target container’s volumes into a new container running a dedicated backup image.

# Using Volumes in Dockerfiles
Docker allows images to define volume mount points with the VOLUME Dockerfile instruction. When a container is started from an image, Docker will automatically create new volumes for the mount points listed in the Dockerfile. The following Dockerfile will always mount a volume to /app_data inside the container, even if you call docker run without the -v flag:
```
FROM ubuntu:22.04
VOLUME /app_data
```

You can still manually mount a new or existing volume to paths referenced by VOLUME instructions. The -v flag overrides the Dockerfile’s content:
```
$ docker run -v custom_volume:/app_data app-image:latest
```

The VOLUME instruction ensures that critical paths are always persisted when users start a new container. However, it should be treated carefully because users won’t necessarily expect this behavior. Using VOLUME removes the choice of creating a purely ephemeral container for debugging or testing purposes.

# Interacting With Docker Volumes
The Docker CLI includes a set of commands for interacting with the volumes on your host.

- List all your volumes with docker volume ls. You’ll see the name of each volume and the storage driver it’s backed by. 
```
$ docker volume ls
DRIVER      VOLUME NAME
local       app_data
local       demo_volume
```

- To access more detailed information about a specific volume, use docker volume inspect instead:
```
$ docker volume inspect demo_volume
[
    {
        "CreatedAt": "2023-03-16T14:05:55Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/demo_volume/_data",
        "Name": "demo_volume",
        "Options": null,
        "Scope": "local"
    }
]
```
- To delete a volume with docker volume rm:
```
$ docker volume rm demo_volume
demo_volume
```

- Volumes which are currently mounted to a container can’t be deleted unless you add the -f (force) flag:
```
$ docker volume rm app_data -f
```

- Finally, you can clean up all unused volumes with docker volume prune. The command deletes volumes that aren’t mounted to at least one container. You’ll be shown a confirmation prompt before the prune begins. After it completes, the total amount of freed disk space will be displayed in your terminal.
```
$ docker volume prune
WARNING! This will remove all local volumes not used by at least one container.
Total reclaimed space: 6B
```

# Using Volumes With Docker Compose
Volumes can also be defined and used in Docker Compose. In your docker-compose.yml file, add a top-level volumes field that lists the volumes to create, then mount your volumes into your containers within the services section:
```
services:
  app:
    image: app-image:latest
    volumes:
      - app_data:/data
volumes:
  app_data:
```

Compose automatically creates and mounts your volumes when you run docker compose up. To use an existing volume, add it to the volumes section of your docker-compose.yml file and set the external flag to true:
```
volumes:
  demo_volume:
    external: true
```

# Source
[Docker Volumes – Guide with Examples](https://spacelift.io/blog/docker-volumes)
