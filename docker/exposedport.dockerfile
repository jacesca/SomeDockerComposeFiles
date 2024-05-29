FROM python:latest

LABEL maintainer="jacesca@gmail.com"

COPY html/index.html /

EXPOSE 8000

# manual execute python -m http.server and then go to http://localhost:8000/
ENTRYPOINT ["python3", "-m", "http.server", "8000"]

# Let the Docker engine know port 8000 should be available

# to build the image
# $ docker build -t exposedport -f .\docker\exposedport.dockerfile .

# execute after
# $ docker run -it --name exposedport -p 8000:8000 exposedport
# then go to:http://localhost:8000/

# Also it can use -P (random port will be assigned)
# $ docker run -d --name exposedport -P exposedport
# $ docker ps -a
#   CONTAINER ID   ...  PORTS                     NAMES
#   398f7d30c5d4   ...  0.0.0.0:32778->8000/tcp   exposedport
# Then go to:http://localhost:32778/
