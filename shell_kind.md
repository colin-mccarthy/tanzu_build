## Prerequisites:

Place the ```clusterIssuer.yaml``` file in the same directory as the script.

Install helm

Modify your Docker Desktop JSON config file to include the insecure-registries section shown in docker.md

Add the hostname to your /etc/hosts file  ```127.0.0.1 core.harbor.domain```

## script

```
#!/bin/bash
#
# 
#

set -oe errexit

# desired cluster name; default is "kind"
KIND_CLUSTER_NAME="kind"


echo "> initializing Kind cluster: ${KIND_CLUSTER_NAME}"

# create a cluster 
cat <<EOF | kind create cluster --name "${KIND_CLUSTER_NAME}" --config=-
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
EOF

echo "> 😊😊 Verify Cluster install"

kubectl wait --for=condition=Ready=true node/kind-control-plane --timeout=30s

kubectl get nodes 

##
## cert-manager
##


echo "> 😊😊 Install Cert-Manager"📦

helm repo add jetstack https://charts.jetstack.io

sleep 5

helm repo update

sleep 5

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.3 \
  --set installCRDs=true


sleep 5

echo "> 😊😊 Verify Cert-Manager install"

kubectl get pods -n cert-manager

kubectl apply -f clusterIssuer.yaml

kubectl wait --for=condition=Ready ClusterIssuer/clusterissuer-self-signed

kubectl get ClusterIssuer


##
## contour
##



echo "> 😊😊 Install Contour"📦

kubectl apply -f https://projectcontour.io/quickstart/contour.yaml

sleep 5

kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'

echo "> 😊😊 Verify Contour install"

sleep 5

kubectl get pods -n projectcontour


##
## harbor
##

echo "> 😊😊 Install Harbor"📦

helm repo add harbor https://helm.goharbor.io

helm install local-harbor harbor/harbor --set externalURL=http://core.harbor.domain/harbor --namespace harbor --create-namespace

echo "> 😊😊 Verify Harbor install"

kubectl -n harbor wait --for=condition=Ready pod/local-harbor-trivy-0 --timeout=60s

sleep 5

kubectl get pods -n harbor

echo "> 😊😊 done!"

```


## Now open a browser session🔧

http://core.harbor.domain/harbor

https://core.harbor.domain/harbor



Default credentails
```
login: admin
pw: Harbor12345
```

