## Install cert-manager via Helm
```
helm repo add jetstack https://charts.jetstack.io
```

```
helm repo update
```

```
$ helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.5.3 \
  --set installCRDs=true
``` 

Verify install

```
kubectl get pods -n cert-manager
```

## Create ClusterIssuer

```
kubectl apply -f clusterIssuer.yaml
```
 
```
kind: ClusterIssuer
apiVersion: cert-manager.io/v1
metadata:
  name: clusterissuer-self-signed
spec:
  selfSigned: {}
```



