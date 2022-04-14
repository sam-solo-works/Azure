<#  Task: Automate creating azure Virtual networks and peers to core azure virtual network.
    Want: Check for vnet prefix prior to implementing.
            Add multiple tags at once.
    Version: 1.5
    Author: Sam Solmonson
    DateWritten: 10/6/2021 DatePublished: -/-/- DateLastChangeMade: 10/12/2021
#>  
$azSub = 'test' #name of azure subscription
$azSubCore = 'test' #name of azure core subscription
$loc = 'test' #location of the resource group in azure
$RG = 'test' #name of Resource Group
$coreRG = 'test' # name of core Resource Group
$sNet = 'test' #name of subnet
$vNet = 'test' #name of new virtual network
<#$tags = @{
'Created By'='Script'
'Owner'='Creator' #Hash table created for tags
'Project'='test'
}#>
$vNetPrefix = '192.168.255.0' #IPs of new virtual network 
$sNetPrefix = '192.168.255.0/27' #IPs of new subnet of new virtual network
$coreVNet = 'test'
#$coreVNetID = 'test'
#$peerCore = $corevnet + "_to_" + $vnet #naming convention for core side peer
#$peerNewVNet = $vNet + "_to_" + $coreVNet #naming convention for vnet side peer
$vnetConnectName = $vnet + "_connection" #naming convention for vnet GW connection


Connect-AzAccount
Select-AzSubscription -SubscriptionName $azSub
if (!(Get-AzVirtualNetwork -Name $vNet -ResourceGroupName $RG | Get-AzVirtualNetworkSubnetConfig | Where {$_.Name -like $sNet})){
    $sNetConfig = New-AzVirtualNetworkSubnetConfig -Name $sNet -AddressPrefix $sNetPrefix 
    New-AzVirtualNetwork -Name $vNet -ResourceGroupName $RG -Location $loc -AddressPrefix $vNetPrefix -Subnet $sNetConfig 
    <#$addTags = (Get-AzVirtualNetwork -Name $vNet -ResourceGroupName $RG).Tag
    foreach($key in $($addTags.keys)){
        if(!$key){
            if ($tags.ContainsKey($key)){
            $addTags.Remove($key)
                }
            }
        }
    $addTags += $tags#>
    $vNetObj = Get-AzVirtualNetwork -Name $vNet -ResourceGroupName $RG
    #Add-AzVirtualNetworkPeering -Name $peerNewVNet -VirtualNetwork $vNetObj -RemoteVirtualNetworkId "/subscriptions/52/vnet"
}    

else{
Write-Host "There is already a network with that config in place."
}

if (Get-AzVirtualNetwork -Name $vNet -ResourceGroupName $RG | Get-AzVirtualNetworkSubnetConfig | Where {$_.name -like $sNet}){
Select-AzSubscription -SubscriptionName $azSubCore
$localGW = Get-AzLocalNetworkGateway -Name test -ResourceGroupName $coreRG
$vNetGW = Get-AzVirtualNetworkGateway -Name test -ResourceGroupName $coreRG
$ipsec = New-AzIpsecPolicy -IkeEncryption AES256 -IkeIntegrity SHA256 -DhGroup DHGroup14 -IpsecEncryption AES256 -IpsecIntegrity SHA256 -PfsGroup None -SALifeTimeSeconds 14400 -SADataSizeKilobytes 102400000
#Add-AzVirtualNetworkPeering -Name $peerCore -VirtualNetwork $coreVNet -RemoteVirtualNetworkId "test" -AllowGatewayTransit
New-AzVirtualNetworkGatewayConnection -Name $vnetConnectName -VirtualNetworkGateway1 $vNetGW  -LocalNetworkGateway2 $localGW -ConnectionType IPsec -IpsecPolicies $ipsec
}

else{
Write-Host "This network has not been built yet."
}
