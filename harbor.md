# Installing Harbor on KinD

Followed this blog

https://serverascode.com/2020/04/28/local-harbor-install.html



## Contour Ingress 🔧

```
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
```

```
kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'
```

```
kubectl get pods -n projectcontour
```

## Helm 🔧

```
brew install helm
```

```
helm repo add harbor https://helm.goharbor.io
```


Added externalURL do to not being able to log in with default UN and PW
```
helm install local-harbor harbor/harbor --set externalURL=http://core.harbor.domain/harbor
```

```
k get pods
```

## Add a hostname to your /etc/hosts file 🔧

```
127.0.0.1 core.harbor.domain
```

## Now open a browser session to http://core.harbor.domain/harbor 🔧

Default credentails
```
login: admin
pw: Harbor12345
```


