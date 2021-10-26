In Harbor create a project named test 



Login to your local Harbor with Docker 
```
docker login core.harbor.domain
```


Pull down a test image for this project 
```
docker pull cmccarth/ticket-function
```



Tag an image for this project 
```
docker tag cmccarth/ticket-function core.harbor.domain/test/ticket-function
```


Push an image to this project 
```
docker push core.harbor.domain/test/ticket-function
```


Verify the image is in Harbor by viewing the repositories for the test project.
