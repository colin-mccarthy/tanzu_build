

 ## Build service install docs

https://docs.pivotal.io/build-service/1-2/installing.html


## Prerequisites: 🔧

 ### Carvel 🔧

Verify that all of the tools are installed and working.

```
ytt version && kapp version && kbld version && kwt version && imgpkg version
``` 


 ### KP-CLI 🔧

Verify the kp-cli is working

```
kp version
```

# Installing Tanzu Build Service on KinD using DockerHub

 ## Relocate Images to a Registry 🔧
 
 
 ```
 docker login
 ```
 
 ```
 docker login registry.pivotal.io
 ```
 
 ```
 imgpkg copy -b "registry.pivotal.io/build-service/bundle:<TBS-VERSION>" --to-repo <IMAGE-REPOSITORY>
 ```
  
  ## Install Tanzu Build Service 🔧
 
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
🔍 Note: This is identical to the IMAGE-REPOSITORY argument provided during imgpkg relocation command. 
 
 
🔍 Exception: When using Dockerhub as your registry target, only use your DockerHub account for this value. For example, my-dockerhub-account (without /build-service). Otherwise, you will encounter an error similar to:
 ```
 Error: invalid credentials, ensure registry credentials for 'index.docker.io/my-dockerhub-account/
 build-service/tanzu-buildpacks_go' are available locally
 ```
 
🔍 An image-pull-secret called tbs-install-pull-secret will be created in the tbs namespace with the registry and registry username/password configured at install time.

 
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
  
 
## Create a secret with container repo creds 🔧

Set registry creds
https://github.com/vmware-tanzu/kpack-cli/blob/main/docs/kp_secret_create.md

### DockeHub
 
 ```
 kp secret create my-registry-creds --dockerhub <username>
 ```
 

 
## Dependency Descriptor file 🔧
Download the Dependency Descriptor file (descriptor-<version>.yaml) from the latest release on the Tanzu Build Service Dependencies page on Tanzu Network. This file contains paths to images that contain dependency resources Tanzu Build Service needs to execute image builds.
 
```
 mkdir build
 cd build
```
 
 ```
 pivnet download-product-files --product-slug='tbs-dependencies' --release-version='100.0.170' --product-file-id=1044254
 ```
 
 Import descriptor file
 
 ```
 kp import -f descriptor-100.0.170.yaml
 ```
 
 
## Create an image 🔧
 
``` 
kp image create dotnet-demo --tag cmccarth/dotnet-demo --git https://github.com/corn-pivotal/TBS-Demo-App.git --git-revision main
``` 
 
 
View default namespace - to see pods spinning up 
 
 ```
 kubectl get pods
 ```
 
 ```
 kp image list
 ```
