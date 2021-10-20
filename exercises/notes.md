


```
#!/usr/bin/env bash

# Create directory to store YAML files
mkdir .k8s

# Create new local CA
mkcert -install
openssl x509 -in "$(mkcert -CAROOT)"/rootCA.pem -inform PEM -out "$(mkcert -CAROOT)"/rootCA.crt

# Start Kind cluster
# @see https://kind.sigs.k8s.io/docs/user/ingress/#create-cluster

CORE_DOMAIN=core.harbor.domain
NOTARY_DOMAIN=notary.harbor.domain
SECRET_NAME=harbor-tls-secret
SUFFIX=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 6 | head -n 1)

cat <<EOF | kind create cluster --name=carvel-${SUFFIX} --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
role: control-plane
  kubeadmConfigPatches:
|
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
        authorization-mode: "AlwaysAllow"
  extraPortMappings:
protocol: TCP
    containerPort: 80
    hostPort: 80
protocol: TCP
    containerPort: 443
    hostPort: 443
containerdConfigPatches:
|-
    [plugins."io.containerd.grpc.v1.cri".containerd]
    disable_snapshot_annotations = true
EOF


# Copy cert to each node
# @see https://gist.github.com/superbrothers/9bb1b7e00007395dc312e6e35f40931e

./kind-load-cafile.sh -n carvel-${SUFFIX} "$(mkcert -CAROOT)"/rootCA.crt

# Add ingress
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'
kubectl wait --for=condition=Ready pods --all --all-namespaces --timeout=120s

# Add cert-manager
helm repo add jetstack https://charts.jetstack.io
helm upgrade --create-namespace --namespace cert-manager --install --wait --timeout 2m --set installCRDs=true --set prometheus.enabled=false cert-manager jetstack/cert-manager

# Create CA cert cluster wide issuer
# @see https://github.com/techgnosis/tanzu-gitops/blob/master/cert-manager/install.sh
cat <<EOF > .k8s/cluster-issuer.yml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: tls-ca-issuer
spec:
  ca:
    secretName: ${SECRET_NAME}
EOF


kapp deploy -a cert-manager \
-f .k8s/cluster-issuer.yml \
-f <(kubectl create secret tls ${SECRET_NAME} \
--cert="$(mkcert -CAROOT)"/rootCA.pem \
--key="$(mkcert -CAROOT)"/rootCA-key.pem \
--namespace cert-manager \
--dry-run=client \
-o yaml) --yes


# Add load balancer
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.10.2/manifests/metallb.yaml

## Create a secret for encrypted speaker communications
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

## Create the config map for the load balancer
cat <<EOF | kubectl create -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
name: address-pool-1
      protocol: layer2
      addresses:
192.168.2.128/25
```
