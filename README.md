# KinD (Kubernetes in Docker)

## Pre Flight

Install XCODE from the App store

Install HomeBrew

 ## Install KinD with Brew


 `brew install kind`
 ```
==> Downloading https://ghcr.io/v2/homebrew/core/kind/manifests/0.11.1
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/kind/blobs/sha256:116a1749c6aee8ad7282caf3a3d2616d11e6193c839c8797cde045cddd0e1138
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:116a1749c6aee8ad7282caf3a3d2616d11e6193c839c8797cde04
######################################################################## 100.0%
==> Pouring kind--0.11.1.big_sur.bottle.tar.gz
==> Caveats
zsh completions have been installed to:
  /usr/local/share/zsh/site-functions
==> Summary
🍺  /usr/local/Cellar/kind/0.11.1: 8 files, 8.4MB
```



`kind version`
```
kind v0.11.1 go1.16.4 darwin/amd64
```


`kind create cluster`
```
Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.21.1) 🖼 
 ✓ Preparing nodes 📦  
 ✓ Writing configuration 📜 
 ✓ Starting control-plane 🕹️ 
 ✓ Installing CNI 🔌 
 ✓ Installing StorageClass 💾 
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind

Thanks for using kind! 😊

kubectl cluster-info --context kind-kind
 
Kubernetes master is running at https://127.0.0.1:56926
CoreDNS is running at https://127.0.0.1:56926/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

`k get nodes`
``` 
NAME                 STATUS   ROLES                  AGE   VERSION
kind-control-plane   Ready    control-plane,master   49s   v1.21.1

```



## M1 Mac Support

https://hub.docker.com/r/rossgeorgiev/kind-node-arm64


Official kind node images target only x86 systems. Although kind can be used to generate ARM64 images, 
it can do so only after building Kubernetes from sources and this is not very practical when using Raspberry Pi for example.

Here's an example of how to start a single node Kubernetes cluster with kind:

`kind create cluster --image rossgeorgiev/kind-node-arm64:v1.20.0`


## context command


`kubectl cluster-info --context kind-kind`



## get / delete cluster

```
kind get clusters

kind delete cluster
```

# Installing Tanzu Build Service

```
brew install pivotal/tap/pivnet-cli
```

```
    wget -O- https://carvel.dev/install.sh | bash
    # Verify that all of the tools are installed and working.
    ytt version && kapp version && kbld version && kwt version && imgpkg version
 ```   

https://docs.pivotal.io/build-service/1-2/installing.html

