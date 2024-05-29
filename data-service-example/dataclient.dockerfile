FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y curl iputils-ping iproute2

ARG LAUNCHPAD_BUILD_ARCH
ARG RELEASE

WORKDIR /src/

COPY code/app_test.sh .

CMD ./app_test.sh


# # Modify the app_test.sh file with the correct ip address
# # Line 1: STATUS_CODE=$(curl --silent --head http://172.26.0.2:5000/tripcount | awk '/^HTTP/{print $2}')
# # You can verify the ip address of the dataservice container
# # $ docker inspect dataservice | jq '.[0].NetworkSettings.Networks.data_net.IPAddress'

# # Build
# # $ docker build -t dataclient -f dataclient.dockerfile .

# # Run
# # $ docker run --name dataclient --network data_net dataclient
