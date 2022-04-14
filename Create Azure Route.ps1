$azSub = read-host -prompt "Enter the Azure Subscription: "
$RG = read-host -prompt "Enter the Resource Group: "
$routeName = read-host -prompt "Enter the name of these routes: "
$routeAddresses = read-host -prompt "Enter the addresses of these routes: "

Connect-AzAccount
Select-AzSubscription -SubscriptionName $azSub