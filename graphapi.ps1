$tenantID = "XXXX"
$appID = "XXXX"
$client_secret = "XXXX"


$url = 'https://login.microsoftonline.com/' + $tenantId + '/oauth2/v2.0/token'

$body = @{
    grant_type = "client_credentials"
    client_id = $appID
    client_secret = $client_secret
    scope = "https://graph.microsoft.com/.default"
}


try { 
        $tokenRequest = Invoke-WebRequest -Method Post -Uri $url -ContentType "application/x-www-form-urlencoded" -Body $body -UseBasicParsing -ErrorAction Stop 
    }
catch {
        Write-Host "Unable to obtain access token, aborting..."; return 
        }

$token = ($tokenRequest.Content | ConvertFrom-Json).access_token

Write-Host $token

$authHeader = @{
   'Content-Type'='application\json'
   'Authorization'="Bearer $token"
}

#########

$ApplicatioListResponse = Invoke-WebRequest -Method Get -Uri "https://graph.microsoft.com/v1.0/users" -ContentType "application/json" -headers $authHeader

$data = ($ApplicatioListResponse.Content | ConvertFrom-Json)

$data.value | ForEach-Object {
    Write-Host $_.userPrincipalName
}

#########

$ApplicatioListResponse2 = Invoke-RestMethod -Method Get -Uri "https://graph.microsoft.com/v1.0/users" -ContentType "application/x-www-form-urlencoded" -headers $authHeader

$ApplicatioListResponse2.value | ForEach-Object {
    Write-Host $_.userPrincipalName
}  

#########

$user = @{
    "userPrincipalName"="user01@skaylink.fet.lt"
    "displayName"="User01"
    "mailNickname"="User01"
    "accountEnabled"=$true
    "passwordProfile"= @{
        "forceChangePasswordNextSignIn" = $false
        "forceChangePasswordNextSignInWithMfa" = $false
        "password"="P@ssw0rd123!"
    }
      } | ConvertTo-Json

$ApplicatioListResponse3 = Invoke-RestMethod -Method Post -Body $user -Uri "https://graph.microsoft.com/v1.0/users" -ContentType "application/json" -headers $authHeader

