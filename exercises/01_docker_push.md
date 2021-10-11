


## In Harbor create a project named test 🔧


Login to your local Harbor with Docker
```
docker login core.harbor.domain
```


Tag an image for this project:
```
docker tag cmccarth/ticket-function core.harbor.domain/test/ticket-function
```


Push an image to this project:
```
docker push core.harbor.domain/test/ticket-function
```

