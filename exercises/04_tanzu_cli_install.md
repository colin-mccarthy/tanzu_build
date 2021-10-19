
# Install Tanzu CLI 1.4.0



## Go to the VMware download site 🔧

https://my.vmware.com/en/web/vmware/downloads/info/slug/infrastructure_operations_management/vmware_tanzu_kubernetes_grid/1_x

locate the Tanzu CLI 1.4.0 download

https://customerconnect.vmware.com/en/downloads/details?downloadGroup=TKG-140&productId=988&rPId=73652

unzip the tar file

## Create a Tanzu directory 🔧
 
 
 ```
 mkdir tanzu
 cd tanzu
 ```

move the unzipped cli directory to your new tanzu directory

```
cd cli
```

Install v1.4.0

```
sudo install core/v1.4.0/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
```

Verify the install and version
 
 ```
 tanzu version
 ```
 example
 
```
version: v1.4.0
buildDate: 2021-08-30
sha: c9929b8f
```
 
 
Install the v1.4.0 plugins
 
 ```
 tanzu plugin install --local ./cli all
 ```
 verify 
 ```
 tanzu package version
 ```
 
 list the plugins
 
 ```
 tanzu plugin list
 ```
 
 

 

 
## resources 

https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.1/tap-0-1/GUID-install.html#mac-cli
