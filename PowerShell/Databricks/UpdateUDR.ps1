$sub=""
$tenant=""
$rg=""
$location=""
$rtName=""
$fqdns="tunnel.canadacentral.azuredatabricks.net", "consolidated-canadacentral-prod-metastore.mysql.database.azure.com", "dbartifactsprodcacentral.blob.core.windows.net", "dbartifactsprodcaeast.blob.core.windows.net", "dblogprodcacentral.blob.core.windows.net", "prod-canadacentral-observabilityeventhubs.servicebus.windows.net"
function Get-IP {
    param(
        $FQDN
    )
    return [System.Net.Dns]::gethostaddresses($FQDN).IPAddressToString
}
Connect-AzAccount -Identity -Subscription $sub -Tenant $tenant
Set-AzContext -Subscription $sub
foreach ($fqdn in $fqdns)
{
    $Route=$null
    $IP=$null
    Write-Output  $fqdn
    $IP=Get-IP -FQDN $fqdn
    $Route=Get-AzRouteTable -ResourceGroupName $rg -Name $rtName | Get-AzRouteConfig -Name $fqdn
    if($IP -ne $null){ 
        if($Route){
            Get-AzRouteTable -ResourceGroupName $rg -Name $rtName | Set-AzRouteConfig -Name $fqdn -AddressPrefix $IP"/32" -NextHopType "Internet" | Set-AzRouteTable
        }else{
            Get-AzRouteTable -ResourceGroupName $rg -Name $rtName | Add-AzRouteConfig -Name $fqdn -AddressPrefix $IP"/32" -NextHopType "Internet" | Set-AzRouteTable
        }
       
    }else{
        Write-Output "Couldn't find IP address"
    } 
}
