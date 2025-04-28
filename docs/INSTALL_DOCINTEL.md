# Document Intelligence containers

### Automatic Infrastructure installation

#### The magic button --> [![Deploy To Azure](../img/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdeuch%2Fai-services-with-containers%2Fmain%2Finfra%2Fdeployment.json)

After deployment, go to  [Software installation](#software-installation) : 

### Manual Infrastructure installation

You can use Cloud Shell for installation. The command are linux oriented.

#### Resource group

Create a resource group for all the resources : 

Linux
```bash
rg_name=docintel-local
location=northeurope

az group create --name $rg_name --location $location
```
Windows
```powershell
$rg_name="docintel-local"
$location="northeurope"

az group create --name $rg_name --location $location
```


#### VNet

Create a VNet in your resource group :

1) Use 10.0.0.0/16 as address space
2) Create a subnet for AKS
    - Name : aks
    - CIDR : 10.0.0.0/24
3) Create a subnet for the VM
    - Name : vms
    - CIDR : 10.0.1.0/27
3) Create a subnet for the private endpoit
    - Name : vms
    - CIDR : 10.0.1.32/27

Linux :
```bash
vnet_name=vnet-local
subnet_aks=aks
subnet_vm=vm
subnet_pe=pe

az network vnet create --name $vnet_name --resource-group $rg_name --location $location --address-prefix 10.0.0.0/16 --subnet-name $subnet_aks --subnet-prefixes 10.0.0.0/24
az network vnet subnet create --name $subnet_vm --resource-group $rg_name --vnet-name $vnet_name --address-prefixes 10.0.1.0/27
az network vnet subnet create --name $subnet_pe --resource-group $rg_name --vnet-name $vnet_name --address-prefixes 10.0.1.32/27
```

Windows

```powershell
$vnet_name="vnet-local"
$subnet_aks="aks"
$subnet_vm="vm"
$subnet_pe="pe"

az network vnet create --name $vnet_name --resource-group $rg_name --location $location --address-prefix 10.0.0.0/16 --subnet-name $subnet_aks --subnet-prefixes 10.0.0.0/24
az network vnet subnet create --name $subnet_vm --resource-group $rg_name --vnet-name $vnet_name --address-prefixes 10.0.1.0/27
az network vnet subnet create --name $subnet_pe --resource-group $rg_name --vnet-name $vnet_name --address-prefixes 10.0.1.32/27
```

#### VM

Create a **Windows** VM, with B4ms SKU in the **vms** subnet.  
Use a login/password to authenticate.
Please set the according values for *--admin-username* and *--admin-password*

Linux : 

```bash
vm_name=vm-ai

az vm create --name $vm_name --resource-group $rg_name --location $location --admin-username "XXXXXXXXX" --admin-password "XXXXXXXXXX" --vnet-name $vnet_name --subnet $subnet_vm --public-ip-address "" --accept-term --license-type Windows_Client --size Standard_B4ms --image MicrosoftWindowsDesktop:Windows-10:win10-22h2-pro:19045.5737.250407
```

Windows :

```powershell
$vm_name="vm-ai"

az vm create --name $vm_name --resource-group $rg_name --location $location --admin-username "XXXXXXXXX" --admin-password "XXXXXXXXXX" --vnet-name $vnet_name --subnet $subnet_vm --public-ip-address "" --accept-term --license-type Windows_Client --size Standard_B4ms --image MicrosoftWindowsDesktop:Windows-10:win10-22h2-pro:19045.5737.250407
```

#### Bastion

When connecting to the VM through the portal, and Bastion with Developper SKU is automatically created.

#### Private DNS Zone

You need to create a Private DNS Zone :

1) Choose a domain name, for eg *aiservices.intra*
2) Create a VNet Link between the Private DNS Zone and the VNet

As an example, we use **aiservices.intre**.

Linux :

```bash
domain="aiservices.intra"

az network private-dns zone create -g $rg_name -n $domain
az network private-dns link vnet create -g $rg_name -n aidnslink -z $domain -v $vnet_name -e true
```

Windows : 

```powershell
$domain="aiservices.intra"

az network private-dns zone create -g $rg_name -n $domain
az network private-dns link vnet create -g $rg_name -n aidnslink -z $domain -v $vnet_name -e true
```

#### Private Endpoint for the AI Resources

1) Create your AI Resource with a custom domain name and public access disabled
2) Create a private endpoint from the AI Resources
3) Integrate with Private DNS Zone (it will create a new one)
4) Ensure that the Private DNS Zone is VNet Linked to your VNet

Linux :

```bash
aiaccount_name=docintelprivate
pe_ai=pe-docintel
az cognitiveservices account create -n $aiaccount_name -g $rg_name --kind FormRecognizer --sku S0 -l $location --yes --custom-domain $aiaccount_name
resourceId=$(az cognitiveservices account show --resource-group $rg_name --name $aiaccount_name --query id --output tsv)
az resource update --ids $resourceId  --set properties.networkAcls="{'defaultAction':'Deny'}"
az resource update --ids $resourceId  --set properties.publicNetworkAccess="Disabled"

az network private-endpoint create --connection-name pe-aiservices --name $pe_ai   --private-connection-resource-id $resourceId  --resource-group $rg_name --subnet $subnet_pe --group-id account --vnet-name $vnet_name

az network private-dns zone create --resource-group $rg_name --name "privatelink.cognitiveservices.azure.com"

az network private-dns link vnet create --resource-group $rg_name --zone-name "privatelink.cognitiveservices.azure.com" --name peaidnslink --virtual-network $vnet_name --registration-enabled false

az network private-endpoint dns-zone-group create --resource-group $rg_name --endpoint-name $pe_ai --name dns-zone-group --private-dns-zone "privatelink.cognitiveservices.azure.com" --zone-name aiservices
```

Windows : 

```powershell
$aiaccount_name="docintelprivate"
$pe_ai="pe-docintel"

az cognitiveservices account create -n $aiaccount_name -g $rg_name --kind FormRecognizer --sku S0 -l $location --yes --custom-domain $aiaccount_name
resourceId=$(az cognitiveservices account show --resource-group $rg_name --name $aiaccount_name --query id --output tsv)
az resource update --ids $resourceId  --set properties.networkAcls="{'defaultAction':'Deny'}"
az resource update --ids $resourceId  --set properties.publicNetworkAccess="Disabled"

az network private-endpoint create --connection-name pe-aiservices --name $pe_ai   --private-connection-resource-id $resourceId  --resource-group $rg_name --subnet $subnet_pe --group-id account --vnet-name $vnet_name

az network private-dns zone create --resource-group $rg_name --name "privatelink.cognitiveservices.azure.com"

az network private-dns link vnet create --resource-group $rg_name --zone-name "privatelink.cognitiveservices.azure.com" --name peaidnslink --virtual-network $vnet_name --registration-enabled false

az network private-endpoint dns-zone-group create --resource-group $rg_name --endpoint-name $pe_ai --name dns-zone-group --private-dns-zone "privatelink.cognitiveservices.azure.com" --zone-name aiservices
```

### AKS Cluster

Create a cluster with 2 nodepools : One for the system and one for your applicatives pods.

Linux :

```bash
cluster_name="aiservices"
subnetResourceId=$(az network vnet subnet show --resource-group $rg_name --vnet-name $vnet_name --name $subnet_aks --query id --output tsv)
 
az aks create --name $cluster_name --resource-group $rg_name --location $location --network-plugin azure --network-plugin-mode overlay --pod-cidr 10.244.0.0/16 --generate-ssh-keys --vnet-subnet-id $subnetResourceId --dns-service-ip 10.4.0.10 --service-cidr 10.4.0.0/24 --node-vm-size Standard_D2s_v3 --node-count 3

az aks nodepool add -g $rg_name -n userai --cluster-name $cluster_name --enable-cluster-autoscaler --min-count 5 --max-count 8 --node-count 5 --node-vm-size Standard_D8s_v5 --vnet-subnet-id $subnetResourceId
```

Windows :

```powershell
$cluster_name="aiservices"
$subnetResourceId=(az network vnet subnet show --resource-group $rg_name --vnet-name $vnet_name --name $subnet_aks --query id --output tsv)
 
az aks create --name $cluster_name --resource-group $rg_name --location $location --network-plugin azure --network-plugin-mode overlay --pod-cidr 10.244.0.0/16 --generate-ssh-keys --vnet-subnet-id $subnetResourceId --dns-service-ip 10.4.0.10 --service-cidr 10.4.0.0/24 --node-vm-size Standard_D2s_v3 --node-count 3

az aks nodepool add -g $rg_name -n userai --cluster-name $cluster_name --enable-cluster-autoscaler --min-count 5 --max-count 8 --node-count 5 --node-vm-size Standard_D8s_v5 --vnet-subnet-id $subnetResourceId
```

## Software Installation

**MANDATORY** : To retrieve credentials of your cluster use the az command. Those credentials are used for each tools (kubectl, helm, linkerd)

```bash
az aks get-credentials --name $cluster_name -g $rg_name --admin --overwrite-existing
```

### Linkerd

To install linkerd, just use those 2 commands :

```bash
linkerd install --crds --set installGatewayAPI=true| kubectl apply -f -
linkerd install | kubectl apply -f -
```
Check that the installation is finished with kubectl command :
```bash
kubectl get pods -n linkerd
```
It must look like :

```console
NAME                                     READY   STATUS    RESTARTS   AGE
linkerd-destination-8fcc4d755-rw7dw      4/4     Running   0          75s
linkerd-identity-5bf6f985f8-ntnvx        2/2     Running   0          75s
linkerd-proxy-injector-f9cf67fc4-4bdt6   2/2     Running   0          74s
```

### Helm template configuration

The helm template provide a lot of options in the values.yaml file.  
A simple one, named custom-docintel-values.yaml will help you the setup everything.
The custom values files are located in [Custom values directory](../charts/custom-values)

Basically you need to set those variables for the first installation of Document Intelligence : 

```yaml
ingress:
  tlsDomain: "aiservices.intra" #Domain of the Private DNS Zone
  autoGenerate: true

#For each model, set enable to True or False 
customTemplate:
  enable: true

layout:
  enable: true

read:
  enable: true

invoice:
  enable: false

receipt:
  enable: true

idDocument:
  enable: true

studio:
  enable: true
```

With Default values, this is what it will be installed/created : 
- Ingress NGINX Controller is installed
  - TLS certificates are automatically generated and set for NGINX (full HTTPS)
- mini-oidc
  - Oauth2/OIDC IDP is installed and 2 users and password are generated
    - One user for API (machine to machine)
    - One user (human) for studio
  - Configmap is created for configuration
  - Secret is created with all the logins/passwords for reference
- ouath2Proxy is installed
  - Auto configured for each ingress and to use mini-oidc as IDP and login page
- Full mTLS within the Linkerd service mesh out of the box

More complex configuration can be done if you decide to use the same cluster with mutiples chart. **More on that in the future**

### Helm installation

**You need to have the endpoint and the apiKey of your AI Resources.**

Let now install the Document Intelligence Helm chart :

1) **Go to the charts directory**
2) In the below command, set :
  - *documentIntelligence.secret.apiKeyValue* with your apiKey
  - *documentIntelligence.secret.endpointValue* with your Document Intelligence endpoint

```bash
helm install di .\ai-document-intelligence -f .\custom-values\custom-docintel-values.yaml -n di --create-namespace --set documentIntelligence.secret.apiKeyValue="XXXXXXXXXXXXXXXX",documentIntelligence.secret.endpointValue="https://mydocintelinstance.cognitiveservices.azure.com/"
```

### Private DNS Zone A Record

**You need to add a record in your Private DNS Zone. Unless, you will not be able to use your VM and reach the studio.**  

Retrieve the private IP of the Load Balancer :

```console
NAME                                          TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)                      AGE
di-ai-document-intelligence-custom-template   ClusterIP      10.4.0.124   <none>        5000/TCP                     7m12s
di-ai-document-intelligence-id-document       ClusterIP      10.4.0.21    <none>        5050/TCP                     7m12s
di-ai-document-intelligence-layout            ClusterIP      10.4.0.233   <none>        5000/TCP                     7m12s
di-ai-document-intelligence-read              ClusterIP      10.4.0.253   <none>        5000/TCP                     7m12s
di-ai-document-intelligence-receipt           ClusterIP      10.4.0.159   <none>        5050/TCP                     7m12s
di-ai-document-intelligence-studio            ClusterIP      10.4.0.67    <none>        5001/TCP                     7m12s
di-ingress-nginx-controller                   LoadBalancer   10.4.0.82    10.0.0.12     80:31590/TCP,443:30690/TCP   7m12s
di-ingress-nginx-controller-admission         ClusterIP      10.4.0.134   <none>        443/TCP                      7m12s
mini-oidc                                     ClusterIP      10.4.0.86    <none>        8000/TCP                     7m12s
oauth2-proxy                                  ClusterIP      10.4.0.18    <none>        4180/TCP                     7m12s
```

In this example, you need to use the external-ip of the Loadbalancer -> 10.0.0.12

```bash
private_ip="10.0.0.12"
az network private-dns record-set a add-record -g $rg_name -z $domain -n "*" -a $private_ip
```
You can add the record directly in the portal too. Use "*" as name and the IP of the load balancer.  

### Connect to the studio

In your VM, use a browser and reach the FQDN of your studio deployment.
The FQDN is returned after the helm installation.  

To retrieve it : 

```console
kubectl get ing -n di
```

Check the HOSTS associated to the studio ingress :  

```console
NAME                                      CLASS   HOSTS                                                    ADDRESS     PORTS     AGE
di-ai-document-intelligence-studio        nginx   docintel.aiservices.intra                                10.0.0.12   80, 443   6m26s
```

To login, use :
  - Username : user
  - Password : the OIDC_USER_SECRET

To retrieve it with Windows :

```console
kubectl get secrets -n di -o jsonpath="{.data.OIDC_USER_SECRET}" oidc-secrets | %{[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_))}
```

With Linux : 

```console
kubectl get secrets -n di -o jsonpath="{.data.OIDC_USER_SECRET}" oidc-secrets | base64 -d
```

### Generate config for your python code

in the [Tools](../tools) directory, you will find some scripts to help you to generate and retrieve all the informations of your deployment (assume **di** is your namespace as set by default): 

**You need to have kubectl installed as the script will use it to retrieve all the informations**  

```shell
.\getconfig.ps1 di
```
It will generate an *.env* file with all the informations you need to use with python for example.  

### Install certificates in the VM

With auto generated certificates, your browser will show you some warnings about non trusted certificates. Follow this guide to install the certificates in your windows desktop :  

Certificates are not Trusted :  

![Certificate is not Trusted](../img/install-certificate-01.png "Certificate is not Trusted")

Check informations about the certificate :  

![Retrieve the certificate](../img/install-certificate-02.png "Retrieve the certificate")

Export the certificate :  

![Export the certificate](../img/install-certificate-03.png "Export the certficate")

Choose PKCS 7 as format with **Certificate chain**  

![Save the certificate](../img/install-certificate-04.png "Save the certificate")

Launch mmc  

![Run MMC](../img/install-certificate-05.png "Run MMC")

Add a snap-in  

![Add a snap-in](../img/install-certificate-06.png "Add a snap-in")

Choose Certificates and click "Add"  

![Add certificate snap-in](../img/install-certificate-07.png "Add certificate snap-in")

Choose Computer Account  

![User computer account](../img/install-certificate-08.png "Use computer account")

Choose the **Trusted Root Certificate Authorities** section to import  the certificate  

![Import the certificate](../img/install-certificate-09.png "Import the certificate")

Choose the previously exported certificate  

![Choose your exported certificate](../img/install-certificate-10.png "Choose your exported certificate")

Verify the certificate file  

![Verify the certificate file](../img/install-certificate-11.png "Verify the certificate file")

Select Next to finalize import :  

![Select Next](../img/install-certificate-12.png "Select Next")

And voilà ! No more error  

![No more error](../img/install-certificate-13.png "No more error")

## Troubleshooting

### Pods

Assume that the namespace is **di** :

Verify that pods are deployed :

```console
kubectl get pods -n di
```

```console
di-ai-document-intelligence-id-document-54799c5866-x5w2k   2/2     Running   0          112m
di-ai-document-intelligence-invoice-85df9bf5f6-2g2sh       2/2     Running   0          112m
di-ai-document-intelligence-layout-65dbc6d467-dppq2        2/2     Running   0          112m
di-ai-document-intelligence-read-5f87d54f7c-vw782          2/2     Running   0          112m
di-ai-document-intelligence-receipt-9499c67c9-k4jxp        2/2     Running   0          112m
di-ai-document-intelligence-studio-5f45fbb674-fgnfd        2/2     Running   0          112m
di-ingress-nginx-controller-75ccd67b94-w5445               2/2     Running   0          112m
mini-oidc-568b975d44-tgj7l                                 2/2     Running   0          112m
oauth2-proxy-7cfb559cd8-hb5f4                              2/2     Running   0          112m
```

Check that every pods are started correctly

### Volumes

Check that the volumes are created and mount :

```console
kubectl get pv
kubectl get pvc -n di
```

```console
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                            STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-2bf79f0a-e887-41fe-a2d5-8d59413737c3   1Gi        RWX            Delete           Bound    di/di-ai-document-intelligence-studio-file       di-azurefile   <unset>                          112m
pvc-69c77187-0b9d-4c41-b141-7c98c63dce08   1Gi        RWX            Delete           Bound    di/di-ai-document-intelligence-output            di-azurefile   <unset>                          112m
pvc-c2a1dbaa-5dd4-4fca-8664-6d1870384c5d   1Gi        RWX            Delete           Bound    di/di-ai-document-intelligence-shared            di-azurefile   <unset>                          112m
pvc-df5b9196-2504-40a0-998a-e28166863fa3   1Gi        RWX            Delete           Bound    di/di-ai-document-intelligence-studio-database   di-azurefile   <unset>                          112m
```
```console
NAME                                          STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
di-ai-document-intelligence-output            Bound    pvc-69c77187-0b9d-4c41-b141-7c98c63dce08   1Gi        RWX            di-azurefile   <unset>                 113m
di-ai-document-intelligence-shared            Bound    pvc-c2a1dbaa-5dd4-4fca-8664-6d1870384c5d   1Gi        RWX            di-azurefile   <unset>                 113m
di-ai-document-intelligence-studio-database   Bound    pvc-df5b9196-2504-40a0-998a-e28166863fa3   1Gi        RWX            di-azurefile   <unset>                 113m
di-ai-document-intelligence-studio-file       Bound    pvc-2bf79f0a-e887-41fe-a2d5-8d59413737c3   1Gi        RWX            di-azurefile   <unset>                 113m
```

Check that the volumes are bound and healthy