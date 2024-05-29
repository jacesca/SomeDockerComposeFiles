FROM golang AS gobuild

WORKDIR /src
COPY scripts/main.go /src/main.go

# Build the go application from source code
RUN go build -o /bin/app_runner /src/main.go

# Create application in standalone container
# Update with the image name from instructions
FROM scratch

# Update with name of previous build stage
COPY --from=gobuild /bin/app_runner /bin/app_runner

CMD ["/bin/app_runner"]


# # Build
# # $ docker build -t "multi-stage" -f .\docker\StageMulti.dockerfile .

# # Determine the size of image
# # $ docker images
# #     REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
# #     multi-stage    latest    4812eb746994   18 seconds ago   1.89MB
# #     single-stage   latest    4ea602e668c1   7 minutes ago    851MB
