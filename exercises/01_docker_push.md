
Login to your local Harbor with Docker
```
docker login core.harbor.domain
```


Tag an image for this project:
```
docker tag SOURCE_IMAGE[:TAG] core.harbor.domain/test/REPOSITORY[:TAG]
```

Push an image to this project:
```
docker push core.harbor.domain/test/REPOSITORY[:TAG]
```

