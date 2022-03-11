<#  Task: Automate changing peer IPs
    Want: 
    Version: 1.0
    Author: Sam Solmonson
    DateWritten: 10/18/2021 DatePublished: 10/18/2021 DateLastChangeMade: 10/19/2021
#>  

$VPNName = 'test' #name of VPN
$azSub = 'test'
$RG = 'test'
$localConnectName = $VPNName + "_local_gateway"
$insidePeerIP = '20.20.20.20/32','43.3.113.102/32' 

Connect-AzAccount
Select-AzSubscription -SubscriptionName $azSub
$LocalGW = Get-AzLocalNetworkGateway -Name $localConnectName -ResourceGroupName $RG
Set-AzLocalNetworkGateway -LocalNetworkGateway $LocalGW -AddressPrefix $insidePeerIP