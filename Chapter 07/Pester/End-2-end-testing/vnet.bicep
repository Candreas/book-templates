targetScope = 'resourceGroup'

param vnetName string
param addressPrefixes array
param subnetName string
param subnetAddressPrefix string
param location string = '${resourceGroup().location}'

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  location: location
  name: vnetName
  properties:{
    addressSpace:{
      addressPrefixes:addressPrefixes 
    }
    subnets:[
      {
        name:subnetName
        properties:{
          addressPrefix: subnetAddressPrefix
           serviceEndpoints: [
             {
               service: 'Microsoft.Web'
               locations:[
                 '*'
               ]
             }
           ]
           delegations: [
             {
               name: 'Microsoft.Web.serverFarms'
               properties: {
                 serviceName: 'Microsoft.Web/serverFarms'
               }
             }
           ]
           privateEndpointNetworkPolicies: 'Enabled'
           privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]    
  }
}

output vnetId string = vnet.id
output subnetId string = vnet.properties.subnets[0].id
