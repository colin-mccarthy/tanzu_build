# Installing Tanzu Build Service

 ## build service install docs

https://docs.pivotal.io/build-service/1-2/installing.html

 ## Carvel 🔧

```
wget -O- https://carvel.dev/install.sh | bash
```

Verify that all of the tools are installed and working.

```
ytt version && kapp version && kbld version && kwt version && imgpkg version
``` 

 ## Pivnet 🔧
 
 https://github.com/pivotal-cf/pivnet-cli
 
```
brew install pivotal/tap/pivnet-cli
```

https://network.tanzu.vmware.com/docs/api#how-to-authenticate <-- get "refresh token" from your profile docs found here.

``` 
pivnet login --api-token='<refresh token>'
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
  
  ## Install Tanzu Build Service Public Registry 🔧
 
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
 
 
 
 ## Verify the install 🔧
 
 Ensure that the kpack controller & webhook have a status of Running using kubectl get.
 
 ```
 kubectl get pods --namespace kpack --watch
 ```
 
 
 
 ## Download the kp binary from the Tanzu Build Service page on Tanzu Network.
 
 ```
 pivnet download-product-files --product-slug='build-service' --release-version='1.2.2' --product-file-id=1000629
 ```
 
 List the cluster builders available in your installation:
 
 ```
 kp clusterbuilder list
 ```

🚨zsh: command not found: kp🚨
 
 ```
 go get github.com/vmware-tanzu/kpack-cli
 ```
 
 ```
 go env GOPATH
 ```

```
% go env GOPATH
/Users/comccarthy/go
% ls /Users/comccarthy/go
bin	pkg
% ls /Users/comccarthy/go/bin 
kp
 ```
 
 ```
 export PATH=$PATH:/Users/comccarthy/go/bin
 ```
 
 ```
 echo $PATH
 ```
 
```
kp clusterbuilder list
```

 Import descriptor file
 
 ```
 kp import -f descriptor-100.0.170.yaml
 ```
 
🚨 Error: failed to get default repository: failed to get default repository: use "kp config default-repository" to set 🚨
 
 
 
Created secret with container repo creds 
 
 ```
 kp secret create my-registry-creds --dockerhub <username>
 ```

 Set default repository
 
 ```
 kp config default-repository <dockerhub-username>
 ```
 
 
 

 
 
 

 
 
