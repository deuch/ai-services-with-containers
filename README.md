# AI Services containers on premise

## Why ?



## How it works ?

### Components

### Architecture and related security

What

## Available charts

You can find the available charts in the [Charts](./charts) directory

The available charts are :

**Document Intelligence with prebuilt model and studio :**

  - Layout
  - Read
  - ID Document
  - Receipt
  - Invoice
  - Custom Template

[Document Intelligence : Installation guide](./docs/INSTALL_DOCINTEL.md)

**Stay Tuned** 

Speech To Text : **WIP**  
Text to Speech : **WIP**  
Languages :
  - PII : **WIP**

## Pre-requisites

  - An Azure AI Resources with Private Endpoint
  - VNet with 3 subnets
    - One for AKS
    - A Second one for the VM
    - A Third one for the private endpoints
  - Private DNS Zone
  - AKS Cluster

### Tools

To install all of the component, you need to download some tools :

[KUBECTL](https://kubernetes.io/releases/download/#binaries)  
[HELM](https://github.com/helm/helm/releases)  
[LINKERD](https://github.com/linkerd/linkerd2/releases)  

Those tools do not need installation, you can use them directly on the path, or add them to a standard path in your OS.

You will need to rename the tools as kubectl(.exe), helm(.exe) and linkerd(.exe). If you are using cloudshell, kubectl and helm are already installed.  

### Azure resources

For simplification, you can use North Europe to install your azure resources (Free Bastion with developper SKU)

You can deploy everything directly with the ARM template or follow the manual instruction.
