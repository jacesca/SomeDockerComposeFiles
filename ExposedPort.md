# Exposed port

For this example we are going to initialize an http python server

1. Create the index html
```
<html>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
```

2. Create the pyserver.dockerfile
```
FROM python:latest

LABEL maintainer="jacesca@gmail.com"

COPY index.html /

EXPOSE 7000

CMD python -m http.server 7000
```

3. Build the image
```
docker build -t pyserver -f .\pyserver.dockerfile .
```

4. First option: Using `-p`
```
docker run -d --name pyserver -p 7000:7000 pyserver
```
> And then go to [http://localhost:7000/](http://localhost:7000/)

5. Second option: Using `-P`. This will assign a random port.
```
docker run -d --name pyserver -P pyserver
```
> And then run docker ps to know the assigned port
```
docker ps -a
```

result in (p.e)
```
   CONTAINER ID   ...  PORTS                     NAMES
   e47a08a52b1c   ...  0.0.0.0:32779->8000/tcp   pyserver
```

Then go to http://localhost:32779/ (p.e.)