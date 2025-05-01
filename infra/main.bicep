@description('Virtual network name')
param vnetName string = 'vnet-spoke'

@description('Virtual network address space')
param vnetAddressSpace string = '10.0.0.0/16'

@description('Document Intelligence (Form Recognizer) service name')
param docIntelligenceName string = 'doc-intelligence-${uniqueString(resourceGroup().id)}'

@description('AKS cluster name')
param aksClusterName string = 'aks-cluster'

@description('Admin username for the virtual machine')
param adminUsername string = 'azureuser'

@description('Admin password for the virtual machine')
@secure()
#disable-next-line secure-parameter-default
param adminPassword string = '@Aa123456789'

@description('Name of the first private DNS zone')
param privateDnsZoneName string = 'aiservices.intra'

@description('The VM SKU for the system node pool (D-series v5 or v6 with 2 vCPUs)')
@allowed([
  'Standard_D2s_v5'
  'Standard_D2as_v5'
  'Standard_D2s_v6'
  'Standard_D2as_v6'
])
param systemNodePoolSku string = 'Standard_D2s_v5'

@description('The VM SKU for the user node pool (D-series v5 or v6 with 8 vCPUs)')
@allowed([
  'Standard_D8s_v5'
  'Standard_D8as_v5'
  'Standard_D8s_v6'
  'Standard_D8as_v6'
])
param userNodePoolSku string = 'Standard_D8s_v5'

// Variables for subnet CIDRs
var aksSubnetCidr = cidrSubnet(vnetAddressSpace, 24, 0)
var vmsSubnetCidr = cidrSubnet(vnetAddressSpace, 27, 8)
var peSubnetCidr = cidrSubnet(vnetAddressSpace, 27, 9)

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      {
        name: 'snet-aks'
        properties: {
          addressPrefix: aksSubnetCidr
        }
      }
      {
        name: 'snet-vms'
        properties: {
          addressPrefix: vmsSubnetCidr
        }
      }
      {
        name: 'snet-pe'
        properties: {
          addressPrefix: peSubnetCidr
        }
      }
    ]
  }

  resource subnetAks 'subnets' existing = {
    name: 'snet-aks'
  }

  resource subnetVms 'subnets' existing = {
    name: 'snet-vms'
  }

  resource subnetPe 'subnets' existing = {
    name: 'snet-pe'
  }
}

// Private DNS Zones
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

resource cognitiveServicesDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'cognitiveservices.azure.com'
  location: 'global'
}

// Virtual Network Links for Private DNS Zones
resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'vnetLink-${privateDnsZone.name}'
  location: 'global'
  parent: privateDnsZone
  properties: {
    virtualNetwork: {
      id: vnet.id
    }
    registrationEnabled: false
  }
}

resource cognitiveServicesDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'vnetLink-${cognitiveServicesDnsZone.name}'
  location: 'global'
  parent: cognitiveServicesDnsZone
  properties: {
    virtualNetwork: {
      id: vnet.id
    }
    registrationEnabled: false
  }
}

// VM NIC
resource nicVm 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'nic-vm'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vnet::subnetVms.id
          }
        }
      }
    ]
  }
}

// Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'vm-win11'
  location: resourceGroup().location
  properties: {
    priority: 'Spot'
    evictionPolicy: 'Deallocate'
    billingProfile: {
      maxPrice: -1
    }
    hardwareProfile: {
      vmSize: 'Standard_D2ads_v5'
    }
    osProfile: {
      computerName: 'vm-win11'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'Windows-11'
        sku: 'win11-24h2-pro'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicVm.id
        }
      ]
    }
  }
}

// Document Intelligence Service (Form Recognizer)
resource docIntelligence 'Microsoft.CognitiveServices/accounts@2021-04-30' = {
  name: docIntelligenceName
  location: resourceGroup().location
  sku: {
    name: 'S0'
  }
  kind: 'FormRecognizer'
  properties: {
    publicNetworkAccess: 'Disabled'
    customSubDomainName: docIntelligenceName
  }
}

// Private Endpoint for Document Intelligence
resource peDocIntelligence 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: 'pe-docIntelligence'
  location: resourceGroup().location
  properties: {
    subnet: {
      id: vnet::subnetPe.id
    }
    privateLinkServiceConnections: [
      {
        name: 'docIntelligenceConnection'
        properties: {
          privateLinkServiceId: docIntelligence.id
          groupIds: [
            'account'
          ]
        }
      }
    ]
  }
}

// Private DNS Zone Group for Document Intelligence
resource dnsGroupPeDocIntelligence 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: 'dnsGroup-${peDocIntelligence.name}'
  parent: peDocIntelligence
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'cognitive-services-config'
        properties: {
          privateDnsZoneId: cognitiveServicesDnsZone.id
        }
      }
    ]
  }
}

// AKS Cluster
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-08-01' = {
  name: aksClusterName
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: 'aksdns'
    networkProfile: {
      networkPlugin: 'azure'
      networkPluginMode: 'overlay'
      networkPolicy: 'calico'
      podCidr: '10.244.0.0/16'
      serviceCidr: '10.2.0.0/24'
      dnsServiceIP: '10.2.0.10'
    }
    agentPoolProfiles: [
      {
        name: 'system'
        mode: 'System'
        count: 3
        vmSize: systemNodePoolSku
        osType: 'Linux'
        enableAutoScaling: false
        vnetSubnetID: vnet::subnetAks.id
      }
      {
        name: 'userpool'
        mode: 'User'
        count: 1
        vmSize: userNodePoolSku
        osType: 'Linux'
        enableAutoScaling: true
        minCount: 5
        maxCount: 8
        vnetSubnetID: vnet::subnetAks.id
      }
    ]
    servicePrincipalProfile: {
      clientId: 'msi'
    }
  }
}

// Role Assignment for AKS
resource aksNetworkContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, aksClusterName, 'NetworkContributor')
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4d97b98b-1d4f-4787-a291-c67834d212e7'
    ) // Network Contributor role ID
    principalId: aksCluster.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
