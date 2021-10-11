
In Harbor create a project named build-service 🔧


## 

With Docker login to registry.pivotal.io 🔧

```
docker login registry.pivotal.io
```

##

```
imgpkg copy -b "registry.pivotal.io/build-service/bundle:1.2.2" --to-repo core.harbor.domain/build-service/
```
