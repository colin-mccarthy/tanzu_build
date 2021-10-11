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
 
 
 
  ## Install Tanzu Build Service  🔧
 
 Pull the Tanzu Build Service bundle image locally using imgpkg.
 
 
 ```
 imgpkg pull -b "core.harbor.domain/build-service/build-service:1.2.2" -o /tmp/bundle --registry-ca-cert-path=/tmp/ca.crt 
 ```
 
Tanzu Build Service 1.2 ships with a dependency updater that can update ClusterStacks, ClusterStores, ClusterBuilders, and the CNB Lifecycle from TanzuNet automatically. Enabling this feature will keep Images up to date with the latest security patches and fixes. To enable this feature, pass in your TanzuNet credentials when running the install command below:
 
 ```
 ytt -f /tmp/bundle/values.yaml \
    -f /tmp/bundle/config/ \
    -f /tmp/ca.crt \
    -v docker_repository='core.harbor.domain/build-service/build-service' \
    -v docker_username='admin' \
    -v docker_password='Harbor12345' \
    -v tanzunet_username='<TANZUNET-USERNAME>' \
    -v tanzunet_password='<TANZUNET-PASSWORD>' \
    | kbld -f /tmp/bundle/.imgpkg/images.yml -f- \
    | kapp deploy -a tanzu-build-service -f- -y
 ```
 
 
 
🔍 Note: This is identical to the IMAGE-REPOSITORY argument provided during imgpkg relocation command. 
 


 
 ## Verify the install 🔧
 
 Ensure that the kpack controller & webhook have a status of Running using kubectl get.
 
 ```
 kubectl get pods -n kpack
 ```
 
 Ensure that the dependency updater was created in the build-service namespace.

 ```
 kubectl get pods -n build-service
 ``` 
 
 List the cluster builders available in your installation:
 
 ```
 kp clusterbuilder list
 ```
  

 
 
 
 

## References

https://github.com/vmware-tanzu/carvel-kapp-controller/issues/39

https://vmtechie.blog/2021/09/11/code-to-container-with-tanzu-build-service/

https://community.pivotal.io/s/article/kapp-controller-reconcile-fails-when-private-registry-uses-self-signed-certs?language=en_US
