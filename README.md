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
 
