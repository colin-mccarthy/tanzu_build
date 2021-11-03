## Add the TAP Package Repository

To add the TAP package repository:

Create a namespace called `tap-install` for deploying the packages of the components by running:

```
kubectl create ns tap-install
```

This namespace is to keep the objects grouped together logically.

## Create a secret for the namespace:

```
kubectl create secret docker-registry tap-registry \
-n tap-install \
--docker-server='registry.pivotal.io' \
--docker-username=TANZU-NET-USER \
--docker-password=TANZU-NET-PASSWORD
```
Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

Note: You must name the secret tap-registry.



## Create the TAP package repository custom resource by downloading the sample-package-repo.yaml file from Tanzu Network.

Alternatively, you can create a file named tap-package-repo.yaml with the following contents:


```
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageRepository
metadata:
 name: tanzu-tap-repository
spec:
 fetch:
   imgpkgBundle:
     image: registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0 #image location
     secretRef:
       name: tap-registry
```

Add TAP package repository to the cluster by applying the `tap-package-repo.yaml` to the cluster:

```
kapp deploy -a tap-package-repo -n tap-install -f ./tap-package-repo.yaml -y
```

Get status of the TAP package repository, and ensure the status updates to Reconcile succeeded by running:

```
tanzu package repository list -n tap-install
```

For example:

```
$ tanzu package repository list -n tap-install
- Retrieving repositories...
  NAME                  REPOSITORY                                                         STATUS               DETAILS
  tanzu-tap-repository  registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0  Reconcile succeeded
```

List the available packages by running:


```
tanzu package available list -n tap-install
```

For example:

```
$ tanzu package available list -n tap-install
/ Retrieving available packages...
  NAME                               DISPLAY-NAME                              SHORT-DESCRIPTION
  accelerator.apps.tanzu.vmware.com  Application Accelerator for VMware Tanzu  Used to create new projects and configurations.                                      
  appliveview.tanzu.vmware.com       Application Live View for VMware Tanzu    App for monitoring and troubleshooting running apps                                  
  cnrs.tanzu.vmware.com              Cloud Native Runtimes                     Cloud Native Runtimes is a serverless runtime based on Knative
```

Note: If using a Tanzu Kubernetes Grid cluster above output will show some other Tanzu packages as well.

List version information for the `cnrs.tanzu.vmware.com` package by running:


```
tanzu package available list cnrs.tanzu.vmware.com -n tap-install
```

For example:


```
$ tanzu package available list cnrs.tanzu.vmware.com -n tap-install
- Retrieving package versions for cnrs.tanzu.vmware.com...
  NAME                   VERSION  RELEASED-AT
  cnrs.tanzu.vmware.com  1.0.1    2021-07-30T15:18:46Z
```



## resources 

https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.1/tap-0-1/GUID-install.html#mac-cli

https://tanzu.vmware.com/developer/guides/gs-tap-on-kind-pt1/
