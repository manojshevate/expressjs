
function Get-ElasticSearchUri {
    param([string]$Environment)

    switch ($Environment) {
        "local" {
            $esHost = "localhost"
        }
        "dev" {
            $esHost = "elasticsearch.dev.informa-agri-labs.com"
        }

        "qa1" {
            $esHost = "agritimeseries.qa1.agri.informa-labs.com"
        }

        "qa2" {
            $esHost = "elasticsearch.qa2.informa-agri-labs.com"
        }

        "prod" {
            $esHost = "elasticsearch.informa-labs.com"
        }
        
        "agri-prod" {
            $esHost = "agritimeseries.prod.agri.informa-labs.com"
        }

        default {
            Write-Host "Error: Unsupported environment '$Environment'."
            exit 1
        }
    }
    return $esHost
}

function Get-KibanaUri {
    param([string]$Environment)

    switch ($Environment) {
        "local" {
            $esHost = "localhost"
        }
        "qa1" {
            $esHost = "logging.qa1.agri.informa-labs.com"
        }
        "agri-prod" {
            $esHost = "logging.prod.agri.informa-labs.com"
        }

        default {
            Write-Host "Error: Unsupported environment '$Environment'."
            exit 1
        }
    }
    return $esHost
}

function Remove-File($path){
    If (Test-Path $path){
        Remove-Item $path
    }
}

function Delete-Index($Name){
    $indexUrl = "http://$($HostName):$($Port)/$Name"

    try {
        Write-Host "DELETE $indexUrl"
        if(!$Plan) {
            Invoke-WebRequest -Uri $indexUrl -Method Delete
        }
        
    }
    catch {
        # Elasticsearch returns 404 if index doesn't exist.
        # This causes Invoke-WebRequest to throw, so swallow.
    }
}

function New-Index-Template($Name, $Template) {
    $templateUrl = "http://$($HostName):$($Port)/_template/$Name"

    Write-Host "PUT $templateUrl"
    Write-Host $Template

    if(!$Plan){
        Invoke-WebRequest -Uri $templateUrl -Method Put -Body $Template
    }
}

function New-Index($Name){
    $indexUrl = "http://$($HostName):$($Port)/$Name"

    if(Index-Exists($Name)){
        Write-Host "Index $Name already exists, skipping create"
    } 
    else {
        Write-Host "PUT $indexUrl"

        if(!$Plan){
            Invoke-WebRequest -Uri $indexUrl -Method Put
        }
    }
}

function Index-Exists($Name){
    $indexUrl = "http://$($HostName):$($Port)/$Name"
    Write-Host "GET $indexUrl"
    
    $request = [System.Net.WebRequest]::Create($indexUrl)
    
    $doesExist = $false
    try {
        $response = $request.GetResponse()
        $doesExist = ($response.StatusCode -eq 200)
        $response.Close()
    }
    catch {
        # will throw exception on 404, this swallows it
    }
    return $doesExist 
}

function New-Alias($Alias, $Index) {
    $url = "http://$($HostName):$($Port)/_aliases"
    $body = @"
    {
        "actions": [
            { 
                "add": {
                    "alias": "$Alias",
                    "index": "$Index"
                }
            }
        ]
    }
"@

    Write-Host "POST $url"
    Write-Host $body

    if(!$Plan){
        Invoke-WebRequest -Uri $url -Method Post -Body $body
    } 
}

function Remove-Alias($Alias, $Index) {
    $url = "http://$($HostName):$($Port)/_aliases"
    $body = @"
    {
        "actions": [
            { 
                "remove": {
                    "alias": "$Alias",
                    "index": "$Index"
                }
            }
        ]
    }
"@

    Write-Host "POST $url"
    Write-Host $body

    if(!$Plan){
        Invoke-WebRequest -Uri $url -Method Post -Body $body
    } 
}

function ReIndex($OldIndex, $NewIndex) {
    $url = "http://$($HostName):$($Port)/_reindex"
    $body = @"
    {
        "source": {
            "index": "$OldIndex"
        },
        "dest": {
            "index": "$NewIndex"
        }
    }
"@
    Write-Host "POST $url"
    Write-Host $body

    if(!$Plan){
        Invoke-WebRequest -Uri $url -Method Post -Body $body
    }
}
