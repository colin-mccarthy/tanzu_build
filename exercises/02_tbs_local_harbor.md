# Install Tanzu Build Service using you local Harbor Registry
 
 
 In Harbor create a project named build-service 🔧


 ## 

 With Docker login to registry.pivotal.io 🔧

 ```
 docker login registry.pivotal.io
 ```

 ##
 
 Attempt to use imgpkg to copy the containers to your local Harbor with a self signed cert 🔧

 ```
  imgpkg copy -b "registry.pivotal.io/build-service/bundle:1.2.2" --to-repo core.harbor.domain/build-service/build-service
 ```
 
 Notice the error you received

 ```
 Error: Retried 5 times: Get "https://core.harbor.domain/v2/": x509: certificate signed by unknown authority
 ```


## 

Download your Registry Certificate from the Harbor UI 🔧

<img src="./screenshots/harbor_cert.png" width="450"> 

##

copy the cert to /tmp/ca.crt 🔧

```
cp Desktop/<ca-5.crt> /tmp/ca.crt
```


##

 Attempt to use imgpkg to copy the containers to your local Harbor with a self signed cert using this flag --registry-ca-cert-path 🔧
 
 ```
 imgpkg copy -b "registry.pivotal.io/build-service/bundle:1.2.2" --to-repo core.harbor.domain/build-service/build-service --registry-ca-cert-path=/tmp/ca.crt 
 ```

## References

https://github.com/vmware-tanzu/carvel-kapp-controller/issues/39

https://vmtechie.blog/2021/09/11/code-to-container-with-tanzu-build-service/

https://community.pivotal.io/s/article/kapp-controller-reconcile-fails-when-private-registry-uses-self-signed-certs?language=en_US
