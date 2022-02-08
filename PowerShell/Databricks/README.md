### Azure Databricks VNET Injection
> If your Azure Databricks workspace is deployed to your own virtual network (VNet), you can use custom routes, also known as user-defined routes (UDR), to ensure that network traffic is routed correctly for your workspace. For example, if you connect the virtual network to your on-premises network, traffic may be routed through the on-premises network and unable to reach the Azure Databricks control plane. User-defined routes can solve that problem.
https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr

However, the IP addresses of some of the external dependencies can change over time and we need to make sure that the UDR is up to date. 

> Warning
>
> Metastore, artifact Blob storage, log Blob storage, DBFS root Blob storage, and Event Hub endpoint IPs can change over time. To prevent a service outage due to IP changes, we suggest that you establish a periodic job to look up these IPs automatically and keep them up to date in your route table.
> 
> To look up metastore IP addresses, see Update your Azure Databricks route tables and firewalls with new MySQL IPs.
> 
> Because metastore IP addresses can change over time, sometimes the same IP address is assigned to the primary and secondary metastores. In that case, you should include only one of the metastores in your route table.
> https://docs.microsoft.com/en-us/azure/databricks/administration-guide/cloud-configurations/azure/udr#--metastore-artifact-blob-storage-log-blob-storage-and-event-hub-endpoint-ip-addresses

You can use this PowerShell script and schedule it via Automation Account to update the UDR regularly. 
