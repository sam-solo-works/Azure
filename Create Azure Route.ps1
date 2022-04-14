$azSub = read-host -prompt "Enter the Azure Subscription"
$RG = read-host -prompt "Enter the Resource Group"
$routeName = read-host -prompt "Enter the name of these routes"
$filename = read-host -prompt "Enter the filepath to the routes csv" #C:\test\AzureRoutes.csv
$routeAddresses = @()
$addRoutes = Import-Csv -path $filename -delimiter ',' | ForEach-Object {$routeAddresses += $_.IPAddress}
$nextHopAddress = #add your next hop address here

function Wait-KeyPress
{
    param
    (
        [string]
        $Message = 'Press Enter to verify',

        [ConsoleKey]
        $Key = [ConsoleKey]::Enter
    )
    
    # emit your custom message
    Write-Host -Object $Message -ForegroundColor Yellow -BackgroundColor Black
    
    # use a blocking call because we *want* to wait
    do
    {
        $keyInfo = [Console]::ReadKey($false)
    } until ($keyInfo.Key -eq $key)
}

write-host "Here are the IP addresses designated for route creation. Please verify."
foreach ($i in $routeAddresses) {
    $i = [ipaddress]$i
    if([ipaddress]$i){
        # $i = $i + "/32"
    Write-Host $i
    }
}
Wait-KeyPress

Connect-AzAccount
Select-AzSubscription -SubscriptionName $azSub

foreach ($i in $routeAddresses) {
    new-Azrouteconfig -Name $routeName -ResourceGroupName $RG -AddressPrefix $i -NextHopType VirtualAppliance -nextHopAddress $nextHopAddress
}