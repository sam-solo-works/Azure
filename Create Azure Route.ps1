$azSub = read-host -prompt "Enter the Azure Subscription"
$RG = read-host -prompt "Enter the Resource Group"
$routeTable = read-host -prompt "Enter the Route Table Name"
$routeName = read-host -prompt "Enter the name of these routes"
$filename = read-host -prompt "Enter the filepath to the routes csv" #C:\test\AzureRoutes.csv
$routeAddresses = @()
$addRoutes = Import-Csv -path $filename -delimiter ',' | ForEach-Object {$routeAddresses += $_.IPAddress}
$nextHopAddress = #add your next hop address here
$count = 0

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
        Write-Host $i
    }
}
Wait-KeyPress

Connect-AzAccount
Select-AzSubscription -SubscriptionName $azSub

$getRouteTable = Get-AzRouteTable -ResourceGroupName $RG -Name $routeTable

foreach ($i in $routeAddresses) {
    $i = $i.tostring()
    $i = $i + "/32"
    if ($count -lt $routeAddresses.count){
        $count++
        $routeNameCounted = $routeName + $count}
    #$route =  Add-AzRouteConfig -Name $routeNameCounted -AddressPrefix $i -NextHopType VirtualAppliance -NextHopIpAddress $nextHopAddress #-RouteTable $getRouteTable
    #$getRouteTable | $route |
    Add-AzRouteConfig -Name $routeNameCounted -AddressPrefix $i -NextHopType VirtualAppliance -NextHopIpAddress $nextHopAddress -RouteTable $getRouteTable | Set-AzRouteTable
}