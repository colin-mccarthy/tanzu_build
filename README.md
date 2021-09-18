# Installing Tanzu Build Service

 ## build service install docs

https://docs.pivotal.io/build-service/1-2/installing.html

 ## carvel

```
    wget -O- https://carvel.dev/install.sh | bash
    # Verify that all of the tools are installed and working.
    ytt version && kapp version && kbld version && kwt version && imgpkg version
 ``` 

 ## pivnet
 
 https://github.com/pivotal-cf/pivnet-cli
 
```
brew install pivotal/tap/pivnet-cli
```

https://network.tanzu.vmware.com/docs/api#how-to-authenticate <-- get "refresh token" from your profile docs found here.

``` 
pivnet login --api-token='my-api-token'
```

Download the kp CLI for your operating system from the Tanzu Build Service page on Tanzu Network

```
pivnet download-product-files --product-slug='build-service' --release-version='1.2.2' --product-file-id=1000629
```


Download the Dependency Descriptor file (descriptor-<version>.yaml) from the latest release on the Tanzu Build Service Dependencies page on Tanzu Network. This file contains paths to images that contain dependency resources Tanzu Build Service needs to execute image builds.
 
```
 mkdir build
 cd build
 
 pivnet download-product-files --product-slug='tbs-dependencies' --release-version='100.0.170' --product-file-id=1044254
 ```

 ## Relocate Images to a Registry
 
 
 ```
 docker login
 ```
 
 ```
 docker login registry.pivotal.io
 ```
 
 ```
 imgpkg copy -b "registry.pivotal.io/build-service/bundle:<TBS-VERSION>" --to-repo <IMAGE-REPOSITORY>
 ```
  
  ## Install Tanzu Build Service Public Registry
 
 Pull the Tanzu Build Service bundle image locally using imgpkg.
 
 Where TBS-VERSION and IMAGE-REPOSITORY are the same values used during relocation.
 
 ```
 imgpkg pull -b "<IMAGE-REPOSITORY>:<TBS-VERSION>" -o /tmp/bundle
 ```
 
Tanzu Build Service 1.2 ships with a dependency updater that can update ClusterStacks, ClusterStores, ClusterBuilders, and the CNB Lifecycle from TanzuNet automatically. Enabling this feature will keep Images up to date with the latest security patches and fixes. To enable this feature, pass in your TanzuNet credentials when running the install command below:
 
 ```
 ytt -f /tmp/bundle/values.yaml \
    -f /tmp/bundle/config/ \
    -v docker_repository='<IMAGE-REPOSITORY>' \
    -v docker_username='<REGISTRY-USERNAME>' \
    -v docker_password='<REGISTRY-PASSWORD>' \
    -v tanzunet_username='<TANZUNET-USERNAME>' \
    -v tanzunet_password='<TANZUNET-PASSWORD>' \
    | kbld -f /tmp/bundle/.imgpkg/images.yml -f- \
    | kapp deploy -a tanzu-build-service -f- -y
 ```
 Note: This is identical to the IMAGE-REPOSITORY argument provided during imgpkg relocation command. 
 
 
Exception: When using Dockerhub as your registry target, only use your DockerHub account for this value. For example, my-dockerhub-account (without /build-service). Otherwise, you will encounter an error similar to: 
 
 
 
 Download the kp binary from the Tanzu Build Service page on Tanzu Network.
 
 ```
 pivnet download-product-files --product-slug='build-service' --release-version='1.2.2' --product-file-id=1000629
 ```
 
 List the cluster builders available in your installation:
 
 ```
 kp clusterbuilder list
 

 zsh: command not found: kp
 ```
 
 
 
 
   ## errors
 
 ```
 kapp: Error: waiting on reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service:
  Finished unsuccessfully (Encountered failure condition Ready == False: CannotImportDescriptor (message: GET https://registry.pivotal.io/v2/tbs-dependencies/bundle/manifests/100.0.170: UNAUTHORIZED: unauthorized to access repository: tbs-dependencies/bundle, action: pull: unauthorized to access repository: tbs-dependencies/bundle, action: pull))
```
 
 ```
 kapp: Error: waiting on reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service:
  Finished unsuccessfully (Encountered failure condition Ready == False: CannotImportDescriptor (message: GET https://registry.pivotal.io/v2/tanzu-dotnet-core-buildpack/dotnet-core/blobs/sha256:acbe937fb23c24dffa5c9e28c27f88540dd17fa0252e1e4a45e0605b223e253e: UNKNOWN: unexpected error; unexpected error))
 ```

 ```
 kapp: Error: waiting on reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service:
  Finished unsuccessfully (Encountered failure condition Ready == False: CannotImportDescriptor (message: GET https://registry.pivotal.io/v2/tanzu-base-bionic-stack/build/blobs/sha256:691bd82d05cb1fc5cca05fc757c0a2f18738562dec528060b72a763b58bc79dd: unexpected status code 502 Bad Gateway: <html>
<head><title>502 Bad Gateway</title></head>
<body>
<center><h1>502 Bad Gateway</h1></center>
<hr><center>nginx</center>
</body>
</html>
))
 ```
