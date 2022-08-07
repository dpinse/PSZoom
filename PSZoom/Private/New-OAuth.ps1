function New-OAuth {

    <#
    .SYNOPSIS
    Retrieves the Zoom OAuth API token
    .DESCRIPTION
    Retrieves the Zoom OAuth API token

    .PARAMETER ClientID
    Client ID of the Zoom App

    .PARAMETER ClientSecret
    Client Secret of the Zoom App

    .PARAMETER AccountID
    Account ID of the Zoom App

    .OUTPUTS
    Zoom API Response

    .NOTES
    Version:        1.0
    Author:         noaboa97
    Creation Date:  20.07.2022
    Purpose/Change: Initial function development
  
    .EXAMPLE
    $clientid = "YourClientID"
    $clientsecret = "YourClientSecret"
    $AccountID = "YourAccountID"

    New-OAuth -ClientID $clientid -ClientSecret $clientsecret -AccountID $AccountID

    .EXAMPLE
    $token = New-OAuth -ClientID $clientid -ClientSecret $clientsecret -AccountID $AccountID

    .LINK
    https://marketplace.zoom.us/docs/guides/build/server-to-server-oauth-app/

    .LINK
    https://marketplace.zoom.us/docs/guides/auth/oauth
    #>

    [CmdletBinding()]
    param (
        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter Zoom App Client ID:", Position = 0)]
        [String]
        $ClientID,

        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter Zoom App Client Secret:", Position = 1)]
        [String]
        $ClientSecret,

        [Parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter Zoom App Account ID", Position = 2)]
        [String]
        $AccountID
    )


    $Uri = "https://zoom.us/oauth/token?grant_type=account_credentials&account_id={0}" -f $AccountID

    #Encoding of the client data
    $IDSecret = $ClientID + ":" + $ClientSecret 
    $EncodedIDSecret = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($IDSecret))

    $headers = @{
        "Authorization" = "Basic $EncodedIDSecret"  
    }
            
    # Maybe add some error handling
    $response = Invoke-WebRequest -uri $Uri -headers $headers -Method Post 

    $token = ($response.content | ConvertFrom-Json).access_token 

    return $token

}
