

## The Kind cluster should have Harbor already installed.

### You can access Harbor via a web browser locally at:

URL: `https://core.harbor.domain` (This should have been set in your `/etc/hosts` file before running the srcipt)

### The default credentials are:

UN: `admin`

PW: `Harbor12345`





## In Harbor create a project named test 🔧

Go to Projects and click the + New Project button.

Set Project Name to `test`.

Set Access Level to Public (unless you intend to make it private and require login).

Leave Storage Quota at the default -1 GB.



## Login to your local Harbor with Docker 🔧
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


## Verify the image is in Harbor by viewing the repositories for the test project 🔧

Go to Projects and select the test project > then the ticket-function repository.

You should now see your image present.
