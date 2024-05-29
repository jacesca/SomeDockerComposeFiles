# Update the FROM line to support a multi-platform build
FROM --platform=$BUILDPLATFORM golang AS gobuild

WORKDIR /src
COPY scripts/main.go /src/main.go

# Define the option to pull environment variables from the host
ARG TARGETOS TARGETARCH

# Build the go application from source code
RUN env GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /bin/app_runner /src/main.go

# Create application in standalone container
# Update with the image name from instructions
FROM scratch

# Update with name of previous build stage
COPY --from=gobuild /bin/app_runner /bin/app_runner

CMD ["/bin/app_runner"]

# # Build with a different platform (for the default)
# # $  docker buildx build --platform linux/arm64 -t platform-stage -f .\docker\StagePlatform.dockerfile .

# # Inspect operative system of the `platform-stage` image
# # $  docker image inspect multi-stage | jq '.[0] | {Platform: (.Os + "\":\"" + .Architecture)}'
# #     {
# #       "Platform": "linux:arm64"
# #     }
# #

# # Reviewing the default operative system for the `single-stage` image (default platform)
# # $ docker image inspect single-stage | jq '.[0] | {Platform: (.Os + "\":\"" + .Architecture)}'
# #     {
# #       "Platform": "linux:amd64"
# #     }
