## Install cluster manager via Helm
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




```
helm install --set ingress.annotations."cert-manager.io/cluster-issuer"=clusterissuer-self-signed
```
or

```
helm install --set expose.ingress.annotations."cert-manager.io/cluster-issuer"=clusterissuer-self-signed harbor harbor/harbor
```
or

```
helm install --set expose.ingress.annotations."cert-manager.io/cluster-issuer"=clusterissuer-self-signed --set expose.tls.secret.secretName=harbor-tls-secret --set expose.tls.secret.notarySecretName=harbor-notary-tls-secret harbor harbor/harbor
```


via 

https://github.com/goharbor/harbor-helm/blob/master/values.yaml




in Harbor download image registry cert


