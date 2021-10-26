# Harbor as Dockerhub proxy


## Set up a Registry Endpoint in Harbor 🔧

Whether doing replication or proxy, you need to configure Dockerhub as a replication endpoint.

Go to Administration -> Registries and click the + New Endpoint button.

Set the Provider and Name both to `Docker Hub`.

You can leave the rest of the settings as default, unless you want access to private images, in which case add in your Access ID and Access Secret.

Press the Test Connection button and then after a successful test hit OK to save.



## Create a Dockerhub Proxy 🔧

Go to Projects and click the + New Project button.

Set Project Name to `dockerhub-proxy`.

Set Access Level to Public (unless you intend to make it private and require login).

Leave Storage Quota at the default `-1` GB.

Set Proxy Cache to `Docker Hub` (the Endpoint we created earlier).




## Test the proxy is working with docker pull:

```
docker pull core.harbor.domain/dockerhub-proxy/library/ubuntu:20.04
```
```
20.04: Pulling from dockerhub-proxy/library/ubuntu
83ee3a23efb7: Pull complete
db98fc6f11f0: Pull complete
f611acd52c6c: Pull complete
Digest: sha256:703218c0465075f4425e58fac086e09e1de5c340b12976ab9eb8ad26615c3715
Status: Downloaded newer image for harbor.aws.paulczar.wtf/dockerhub-proxy/library/ubuntu:20.04
harbor.aws.paulczar.wtf/dockerhub-proxy/library/ubuntu:20.04
```



# Configure Docker Hub Replication 🔧

With Proxy-ing enabled, let’s now turn our eyes to Replication. This is where we can surgically select which images we want to make available.

Go to Projects and click the + New Project button.

Set Project Name to `dockerhub-replica`.

Leave all other settings as their defaults.



## Create a Replication Rule
Next we create a Replication Rule to determine the specific Images we want to replicate. In this case we want only the library/python:3.8.2-slim image. We restrict this as Replication can quickly hit the Docker Hub rate limits.

The resource filters support basic pattern recognition, so you could use library/** if you wanted to replicate all of the official images, however this would quickly hit the rate limits.

Go to Administration -> Replication and click the + New Replication Rule button.

Set Name to `dockerhub-python-slim`

Set Replication mode to Pull-based

Set Source registry to `Docker Hub`

Set Source resource filter -> Name to `library/python`

Set Source resource filter -> Tag to `3.8.2-slim`

Set Destination namespace to `dockerhub-replica/python`

Leave the rest as their defaults.





## references

https://tanzu.vmware.com/developer/guides/harbor-as-docker-proxy/
