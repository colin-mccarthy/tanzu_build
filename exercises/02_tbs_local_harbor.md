
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

```
Error: Retried 5 times: Get "https://core.harbor.domain/v2/": x509: certificate signed by unknown authority
```

https://github.com/vmware-tanzu/carvel-kapp-controller/issues/39

https://vmtechie.blog/2021/09/11/code-to-container-with-tanzu-build-service/


<img src="./docs/screenshots/harbor_cert.png" width="450"> 
