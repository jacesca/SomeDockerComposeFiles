FROM golang
WORKDIR /src
COPY scripts/main.go /src/main.go

# Build the go application from source code
RUN go build -o /bin/app_runner /src/main.go

CMD ["/bin/app_runner"]

# # Build
# # $ docker build -t "single-stage" -f .\docker\StageSingle.dockerfile .

# # Determine the size of image
# # $ docker images
# #     REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
# #     multi-stage    latest    4812eb746994   18 seconds ago   1.89MB
# #     single-stage   latest    4ea602e668c1   7 minutes ago    851MB
