# Docker Network

## Docker Network Types
Docker comes with five built-in network drivers that implement core networking functionality:
1. **bridge**
> Bridge networks create a software-based bridge between your host and the container. Containers connected to the network can communicate with each other, but they’re isolated from those outside the network.
> 
> Each container in the network is assigned its own IP address. Because the network’s bridged to your host, containers are also able to communicate on your LAN and the internet. They will not appear as physical devices on your LAN, however.

2. **host**
> Containers that use the host network mode share your host’s network stack without any isolation. They aren’t allocated their own IP addresses, and port binds will be published directly to your host’s network interface. This means a container process that listens on port 80 will bind to <your_host_ip>:80.

3. **overlay**
> Overlay networks are distributed networks that span multiple Docker hosts. The network allows all the containers running on any of the hosts to communicate with each other without requiring OS-level routing support.
> 
> Overlay networks implement the networking for Docker Swarm clusters, but you can also use them when you’re running two separate instances of Docker Engine with containers that must directly contact each other. This allows you to build your own Swarm-like environments.

4. **ipvlan**
> IPvLAN is an advanced driver that offers precise control over the IPv4 and IPv6 addresses assigned to your containers, as well as layer 2 and 3 VLAN tagging and routing.
>
> This driver is useful when you’re integrating containerized services with an existing physical network. IPvLAN networks are assigned their own interfaces, which offers performance benefits over bridge-based networking.

5. **macvlan**
> macvlan is another advanced option that allows containers to appear as physical devices on your network. It works by assigning each container in the network a unique MAC address.
> 
> This network type requires you to dedicate one of your host’s physical interfaces to the virtual network. The wider network must also be appropriately configured to support the potentially large number of MAC addresses that could be created by an active Docker host running many containers.


## Which Network Type Should I Use?
- Bridge networks are the most suitable option for the majority of scenarios you’ll encounter. Containers in the network can communicate with each other using their own IP addresses and DNS names. They also have access to your host’s network, so they can reach the internet and your LAN.

- Host networks are best when you want to bind ports directly to your host’s interfaces and aren’t concerned about network isolation. They allow containerized apps to function similarly to network services running directly on your host.

- Overlay networks are required when containers on different Docker hosts need to communicate directly with each other. These networks let you set up your own distributed environments for high availability.

- Macvlan networks are useful in situations where containers must appear as a physical device on your host’s network, such as when they run an application that monitors network traffic. IPvLAN networks are an advanced option for when you have specific requirements around container IP addresses, tags, and routing.

- Docker also supports third-party network plugins, which expand the networking system with additional operating modes. These include Kuryr, which implements networking using OpenStack Neutron, and Weave, an overlay network with an emphasis on service discovery, security, and fault tolerance.

- Finally, Docker networking is always optional at the container level: setting a container’s network to none will completely disable its networking stack. The container will be unable to reach its neighbors, your host’s services, or the internet. This helps improve security by sandboxing applications that aren’t expected to require connectivity.

## Creating Networks
To create a new network, use the docker network create command. You can specify the driver to use, such as bridge or host, by setting the -d flag. A bridge network will be created if you omit the flag.
```
$ docker network create demo-network -d bridge
50ed05634f6a3312e56700ef683ca39df44bfc826e2e4da9179c2593c79910f9
```

## Connecting Containers to Networks
You can attach new containers to a network by setting the --network flag with your docker run command. Run this command in your second terminal window:
```
$ docker run -it --rm --name container1 --network demo-network busybox:latest
```

Next, open your third terminal window and start another Ubuntu container, this time without the --network flag:
```
$ docker run -it --rm --name container2 busybox:latest
```

Now try communicating between the two containers, using their names:
```
# in container1
$ ping container2
ping: bad address 'container2'
```

The containers aren’t in the same network yet, so they can’t directly communicate with each other. Use your first terminal window to join container2 to the network:
```
$ docker network connect demo-network container2
```

The containers now share a network, which allows them to discover each other:
```
# in container1
$ ping container2
PING container2 (172.22.0.3): 56 data bytes
64 bytes from 172.22.0.3: seq=0 ttl=64 time=4.205 ms
```


## Using Host Networking
Bridge networks are what you’ll most commonly use to connect your containers. Let’s also explore the capabilities of host networks, where containers attach directly to your host’s interfaces. You can enable host networking for a container by connecting it to the built-in host network:
```
$ docker run -d --name nginx --network host nginx:latest
```

NGINX listens on port 80 by default. Because the container’s using a host network, you can access your NGINX server on your host’s localhost:80 outside the container, even though no ports have been explicitly bound:
```
$ curl localhost:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```

## Disabling Networking
When a container’s networking is disabled, it will have no connectivity available – either to other containers, or your wider network. Disable networking by attaching your container to the none network:
```
$ docker run -it --rm --network none busybox:latest
/ # ping google.com
ping: bad address 'google.com'
``` 

This lets you easily sandbox unknown services.

## Removing Containers from Networks
Docker lets you freely manage network connections without restarting your containers. In the previous section, you saw how to connect a container after its creation; it’s also possible to remove containers from networks they no longer need to participate in:
```
$ docker network disconnect demo-network container2
```

Any changes you make will apply immediately.


## Managing Networks
You can list all your Docker networks with the network ls command:
```
$ docker network ls
NETWORK ID     NAME           DRIVER    SCOPE
44edcc537a6f   bridge         bridge    local
2cf9f8f370ad   demo-network   bridge    local
4d60b27f787a   host           host      local
288376a0a4f8   none           null      local
```

The output includes the built-in networks, bridge, host, and none, as well as the networks you’ve created.

To delete a network, disconnect or stop all the Docker containers that use it, then pass the network’s ID or name to network rm:
```
$ docker network rm demo-network
```

You can automatically delete all unused networks using the network prune command:
```
$ docker network prune
```


## Using Networks With Docker Compose
You can use networks with Docker Compose services too. It’s often possible to avoid manual networking configuration when you’re using Compose, because the services in your stack are automatically added to a shared bridge network:
```
version: "3"
services:
  app:
    image: php:7.2-apache
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD=changeme
```

Use Compose to deploy the stack:
```
$ docker compose up -d
[+] Running 3/3
 ✔ Network introduction-to-docker-networking_default    Created            0.1s 
 ✔ Container introduction-to-docker-networking-mysql-1  Started            3.7s 
 ✔ Container introduction-to-docker-networking-app-1    Started            3.7s
```

As shown by the following output, Compose has created a network for your stack that includes both the containers:
```
$ docker network ls
NETWORK ID     NAME                                        DRIVER    SCOPE
44edcc537a6f   bridge                                      bridge    local
4d60b27f787a   host                                        host      local
358610a7ea97   introduction-to-docker-networking_default   bridge    local
288376a0a4f8   none                                        null      local
```

This means your application container can communicate directly with the neighboring mysql database container:
```
$ docker compose exec -it app bash
root@d7c97936ad48:/var/www/html# apt update && apt install iputils-ping -y
root@d7c97936ad48:/var/www/html# ping mysql
PING mysql (172.23.0.3) 56(84) bytes of data.
64 bytes from introduction-to-docker-networking-mysql-1.introduction-to-docker-networking_default (172.23.0.3): icmp_seq=1 ttl=64 time=0.493 ms
```

### Adding Extra Networks

You can define additional networks inside your Compose file. Name the network in the top-level networks field, then connect your services by referencing the network in the service-level networks field:
```
version: "3"
services:
  app:
    image: php:7.2-apache
    networks:
      - db
  helper:
    image: custom-image:latest
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD=changeme
    networks:
      - db
networks:
  db:
```

This example overrides the behavior of the default stack-level network. Now, only the app service can communicate with mysql. helper is unable to reach the database because the two services don’t share a network.
