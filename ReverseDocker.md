# To get a dockerfile from image

You can execute the following code:
```
docker history --no-trunc --format 'RUN {{.CreatedBy}}' <image-name>
```

Source: [Is it possible to extract the Dockerfile from a docker container](https://stackoverflow.com/questions/24360556/is-it-possible-to-extract-the-dockerfile-from-a-docker-container)