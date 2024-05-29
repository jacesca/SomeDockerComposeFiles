FROM ubuntu

LABEL maintainer="jacesca@gmail.com"

RUN apt-get update
RUN apt-get -y install python3
RUN apt-get -y install python3-pip

WORKDIR /home/

COPY config/config.json .
COPY scripts/readjson.py .

CMD python3 readjson.py

# # Build the image
# # $ docker build -t exposedport -f .\docker\exposedport.dockerfile .

# # Run the container
# # docker run --name readjson-default -it readjson

# Run with a different config file
# docker run --name readjson-new -v C:/projects/config/configenv.json:/home/config/config.json readjson
