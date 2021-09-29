Install cluster manager via Helm

 K apply -f 
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
