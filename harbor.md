#Install Harbor

https://serverascode.com/2020/04/28/local-harbor-install.html



## Contour Ingress

```
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
```

```
kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'
```
