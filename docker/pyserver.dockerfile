FROM python:latest

LABEL maintainer="jacesca@gmail.com"

COPY html/index.html /

EXPOSE 7000

CMD python -m http.server 7000

# to build the image
# $ docker build -t pyserver -f .\docker\pyserver.dockerfile .

# execute after
# $ docker run -it --name pyserver -p 7000:7000 pyserver
# then go to:http://localhost:7000/

# execute: 
# $ docker run -it --name pyserver -p 80:7000 pyserver
# then go: http://localhost/

# Also it can use -P (random port will be assigned)
# $ docker run -d --name pyserver -P pyserver
# $ docker ps -a
#   CONTAINER ID   ...  PORTS                     NAMES
#   e47a08a52b1c   ...  0.0.0.0:32779->8000/tcp   pyserver
# Then go to:http://localhost:32779/
