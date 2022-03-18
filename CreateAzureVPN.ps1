<#  Task: Automate creating azure VPNs
    Want: 
    Version: 1.0
    Author: Sam Solmonson
    DateWritten: 10/13/2021 DatePublished: 10/18/2021 DateLastChangeMade: 10/18/2021
#>  
$VPNName = 'test' #name of new VPN
$azSub = ''
$azSubProd = '' #Production azure subscription
$RG = ''
$tags = @{CreatedBy="Automated Script";Owner="Enterprise Networking";Application="Intersystems";Task="VPN"}
$loc = 'East US 2'
$VPNConnectName = $VPNName + "_connection"
$localConnectName = $VPNName + "_local_gateway" 
$publicPeerIP = '1.1.1.1' #public IP of hospital side of VPN.
$insidePeerIP = '22.2.2.2/32','3.3.3.3/32' #private network of hospital side of VPN.

Connect-AzAccount
Select-AzSubscription -SubscriptionName $azSub
$vNetGW = Get-AzVirtualNetworkGateway -Name  -ResourceGroupName $RG
$ipsec = New-AzIpsecPolicy -IkeEncryption AES256 -IkeIntegrity SHA256 -DhGroup DHGroup14 -IpsecEncryption AES256 -IpsecIntegrity SHA256 -PfsGroup None -SALifeTimeSeconds 28800 #-SADataSizeKilobytes 102400000
New-AzLocalNetworkGateway -Name $localConnectName -ResourceGroupName $RG -Location $loc -GatewayIpAddress $publicPeerIP -AddressPrefix $insidePeerIP -Tag $tags
$newLocalGW = Get-AzLocalNetworkGateway -Name $localConnectName -ResourceGroupName $RG
New-AzVirtualNetworkGatewayConnection -Name $VPNConnectName -ResourceGroupName $RG -Location $loc -VirtualNetworkGateway1 $vNetGW  -LocalNetworkGateway2 $newLocalGW -ConnectionType IPsec -UsePolicyBasedTrafficSelectors $true -Tag $tags #-IpsecPolicies $ipsec 


Write-Host "Remember to add NSG rule to the VNET!" -ForegroundColor Red