<#  Task: Create PS scrip to check azure VM route tables
    Want: Check VM route tables without logging into Azure
    Version: 2.0
    Author: Sam Solmonson
    DateWritten: 3/9/2022 DatePublished: 3/9/2022 DateLastChangeMade: 3/10/2022
#>  

$VMName = Read-Host "What is the name of the VM you would like to see the route table of?" # #name of virtual machine you would like to check
$azSub = Read-Host "Which Azure subscription does this VM live in?" # #which subscription does this VM live in
$RG = Read-Host "Which Azure resource group does this VM live in?" # # change this if the VM is in a different resource group
$nicName = $vmname + "-nic"
$file = "\\share-01\shared\IT\Network\Logs\Azure\" + $VMName + "_Route_Table.csv"

$VMName
$azSub
$RG

$allRoutes = Get-AzEffectiveRouteTable -NetworkInterfaceName $nicName <#if the nic has any special sort of name other than the VMname-nic please remove this variable and put that name in quotes here#> -ResourceGroupName $RG 

Connect-AzAccount
Select-AzSubscription -SubscriptionName $azSub

$allRoutes | ForEach-Object {
    New-Object -TypeName PSObject -Property @{
        Name                         = $_.Name -join ';'
        State                        = $_.State -join ';'
        Source                       = $_.Source -join ';'
        Address_Prefix               = $_.AddressPrefix -join ';'
        NextHopType                  = $_.NextHopType -join ';'
        NextHopIP                    = $_.NextHopIpAddress -join ';'
    }
} | Sort-Object Name,State,Source,Address_Prefix,NextHopType,NextHopIP | Export-Csv -Path $file -NoTypeInformation -Force