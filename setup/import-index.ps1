 
$sb = {
    Import-Module $PSScriptRoot\core.ps1 -Force
    $Port = 9200
    $HostName = "localhost"

    $kitchenIndex = "kitchen"


    $kitchenIndexTemplate = @"
    {{
      "template": "{0}*",
      "aliases": {{
            "{1}": {{}}
        }},
      "settings": {{
        "analysis": {{
            "filter": {{
                "autocomplete_filter": {{ 
                    "type":     "edge_ngram",
                    "min_gram": 1,
                    "max_gram": 20
                }}
            }},
            "analyzer": {{
                "autocomplete": {{
                    "type":      "custom",
                    "tokenizer": "autocomplete_tokenizer",
                    "filter": [
                        "lowercase",
                        "autocomplete_filter" 
                    ]
                }}
            }},
            "tokenizer": {{
                "autocomplete_tokenizer": {{
                    "type": "edge_ngram",
                    "min_gram": 1,
                    "max_gram": 20,
                    "token_chars": [
                    "letter",
                    "digit"
                    ]
                }}
                }}
            }}
        }},
      "mappings": {{
        "_default_": {{
          "properties": {{
            "id": {{
              "index": "not_analyzed",
              "type": "string"
            }}
          }}
        }}
      }}
    }}
"@
    
    $alias = "$($kitchenIndex)-alias"
    $formatedIndexTemplate = $kitchenIndexTemplate -f $kitchenIndex, $alias
    New-Index-Template -Name $kitchenIndex -Template $formatedIndexTemplate

    New-Index "kitchen"
}

Invoke-Command -ScriptBlock $sb