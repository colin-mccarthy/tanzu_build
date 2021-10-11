
## Prerequisites: CLI Tools 🔧

 ### Install Carvel 🔧

```
wget -O- https://carvel.dev/install.sh | bash
```

Verify that all of the tools are installed and working.

```
ytt version && kapp version && kbld version && kwt version && imgpkg version
``` 

 ### Install Pivnet-CLI 🔧
 

```
brew install pivotal/tap/pivnet-cli
``` 

🔍 Get "refresh token" from your Tanzu Net profile: docs found here --> https://network.tanzu.vmware.com/docs/api#how-to-authenticate

Login with pivnet
``` 
pivnet login --api-token='<refresh token>'
```


 
 
 ### Install KP-CLI 🔧
 
Download the kp CLI for your operating system from the Tanzu Build Service page on Tanzu Network

```
pivnet download-product-files --product-slug='build-service' --release-version='1.2.2' --product-file-id=1000629
```

🔍 Note: Make the file executable

```
chmod +x /path/to/your/file.txt
```

🔍 For Mac users: Try to execute the file, so your Mac will open the security settings.. Then allow the file to be opened.

 ```
 sudo ./kp-darwin-0.2.0 
 ```


 
🔍 Note: Move the file to your PATH

 ```
 echo $PATH
 
 mv ./kp-darwin-0.2.0 /usr/local/bin
 ```

Verify the kp-cli is working

```
kp version
```


 ### Docker Login  🔧
 
 ```
 docker login
 ```
 
 ```
 docker login registry.pivotal.io
 ```
 
