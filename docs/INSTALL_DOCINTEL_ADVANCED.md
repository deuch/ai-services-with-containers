# Manual Infrastructure installation

You can use Cloud Shell for installation. The command are linux oriented.

## Resource group

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


## VNet

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

## VM

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

## Bastion

When connecting to the VM through the portal, and Bastion with Developper SKU is automatically created.

## Private DNS Zone

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

## Private Endpoint for the AI Resources

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

## AKS Cluster

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

## Software installation

Now go to [Software installation](./INSTALL_DOCINTEL.md#software-installation) to continue your adventure :) 