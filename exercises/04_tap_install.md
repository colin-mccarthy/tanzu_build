https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/0.1/tap-0-1/GUID-install.html#mac-cli





### Install Tanzu CLI 

https://my.vmware.com/en/web/vmware/downloads/info/slug/infrastructure_operations_management/vmware_tanzu_kubernetes_grid/1_x
 
 
 
 ```
 mkdir tanzu
 cd tanzu
 ```
 
 ```
 pivnet download-product-files --product-slug='tanzu-application-platform' --release-version='0.2.0' --product-file-id=1055576
 ```
 
 ```
 tar -xvf tanzu-framework-darwin-amd64.tar -C .
 ```
 
 ```
 sudo install  cli/core/v0.5.0/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
 ```
 
 ```
 tanzu version
 ```
 
 ```
 tanzu plugin install --local ./cli all
 ```
 
 ```
 tanzu package version
 ```
 
