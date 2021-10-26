# Harbor as Dockerhub proxy


## Set up a Registry Endpoint in Harbor

Whether doing replication or proxy, you need to configure Dockerhub as a replication endpoint.

Go to Administration -> Registries and click the + New Endpoint button.

Set the Provider and Name both to `Docker Hub`.

You can leave the rest of the settings as default, unless you want access to private images, in which case add in your Access ID and Access Secret.

Press the Test Connection button and then after a successful test hit OK to save.



## Create a Dockerhub Proxy

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



## references

https://tanzu.vmware.com/developer/guides/harbor-as-docker-proxy/
