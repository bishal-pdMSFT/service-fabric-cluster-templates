function Create-Object
{
    Param (
        [String]
        $TypeName,

        [Object[]]
        $ArgumentList
    )

    return New-Object -TypeName $TypeName -ArgumentList $ArgumentList
}

$connectionParametersWithGetMetadata = @{
    'ServerCertThumbprint' = '24B2E50B1779AAE0F80BD4DDAB065BE214DCA896'
    'ConnectionEndpoint' = 'bishalsfaad2.southindia.cloudapp.azure.com:19000'
    'AzureActiveDirectory' = $true
    'GetMetadata' = $true
}

$connectResult = Connect-ServiceFabricCluster @connectionParametersWithGetMetadata
$authority = $connectResult.AzureActiveDirectoryMetadata.Authority
Write-Host $authority
$clusterApplicationId = $connectResult.AzureActiveDirectoryMetadata.ClusterApplication
Write-Host $clusterApplicationId
$clientApplicationId = $connectResult.AzureActiveDirectoryMetadata.ClientApplication
Write-Host $clientApplicationId

# Acquire AAD access token
Add-Type -LiteralPath "$PSScriptRoot\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
$authContext = Create-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList @($authority, $null)
#$authParams = $ConnectedServiceEndpoint.Auth.Parameters

$userCredential = Create-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential -ArgumentList @("username@microsoft.com", "***")
#$clientCredential = Create-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential -ArgumentList @("1548a4b9-e097-4b71-aa8a-28997cf35178", "X78SA0GkWKqfuxPiCTdyCoBPAChwsljJujb3d1tgFFY=")

# Acquiring a token using UserCredential implies a non-interactive flow. No credential prompts will occur.
$accessToken = $authContext.AcquireToken($clusterApplicationId, $clientApplicationId, $userCredential).AccessToken
#$accessToken = $authContext.AcquireToken($clusterApplicationId, $clientCredential).AccessToken


Write-Host $accessToken


