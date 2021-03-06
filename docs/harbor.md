# Installing Harbor on KinD

Followed this blog

https://serverascode.com/2020/04/28/local-harbor-install.html



## Contour Ingress π§

```
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
```

```
kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'
```

```
kubectl get pods -n projectcontour
```

## Helm π§

```
brew install helm
```

```
helm repo add harbor https://helm.goharbor.io
```

### http
π Added externalURL flag to be able to log in with default UN and PW
```
helm install local-harbor harbor/harbor --set externalURL=http://core.harbor.domain/harbor --namespace harbor --create-namespace
```

### https
π For cert-manager installs add ingress.annotations
```
helm install local-harbor harbor/harbor --set ingress.annotations."cert-manager.io/cluster-issuer"=clusterissuer-self-signed --namespace harbor --create-namespace
```

Verify install
```
kubectl get pods -n harbor
```

## Add a hostname to your /etc/hosts file π§

```
127.0.0.1 core.harbor.domain
```

## Now open a browser sessionπ§

http://core.harbor.domain/harbor

https://core.harbor.domain/harbor



Default credentails
```
login: admin
pw: Harbor12345
```


