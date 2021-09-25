# Setup KinD


Followed this blog

https://serverascode.com/2020/04/28/local-harbor-install.html


## Install KinD 🔧

```
brew install kind
```

## Create Cluster with use of “extraPortMappings” 🔧


kind.yaml
```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
        authorization-mode: "AlwaysAllow"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
```

```
kind create cluster --config=kind.yaml 
```

```
kubectl get nodes
```


