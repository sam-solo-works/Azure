$azSub = read-host -prompt "Enter the Azure Subscription"
$RG = read-host -prompt "Enter the Resource Group"
$routeName = read-host -prompt "Enter the name of these routes"
$routeAddresses = @()
$addressAdd = (read-host -prompt "Enter the addresses of these routes. Type 'end' when finished")
$pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"

Connect-AzAccount
Select-AzSubscription -SubscriptionName $azSub
do{
    if ($addressAdd -ne "" -and $addressAdd -ne $null -and $addressAdd -match $pattern){
        $routeAddresses += $addressadd
        Start-Sleep
        [System.Threading.Thread]::Sleep()
        Read-Host
        [Console]::ReadKey()
        $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}
until ($addressAdd -eq 'end')
$routeAddresses