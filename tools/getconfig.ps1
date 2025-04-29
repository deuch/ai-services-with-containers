
# Variables
$namespace = $args[0]
$secretName = "oidc-secrets"
$certificateName = "tls-ingress-secret"
$configMapName="mini-oidc-config"
$apiEndpointCm="api-endpoints"
$outputFile = ".env"

# Récupérer le secret en format JSON
$secretJson = kubectl get secret $secretName -n $namespace -o json

# Convertir le JSON en objet PowerShell
$secretObject = $secretJson | ConvertFrom-Json

# Initialiser une chaîne vide pour stocker le contenu du fichier .env
$envContent = ""

# Parcourir les données du secret et les décoder
foreach ($key in $secretObject.data.PSObject.Properties.Name) {
  $value = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($secretObject.data.$key))
  $envContent += "$key=`"$value`"`n"
}

$configMapJson =  kubectl get cm $apiEndpointCm -n $namespace -o json 
$configMapObject = $configMapJson | ConvertFrom-Json

foreach ($key in $configMapObject.data.PSObject.Properties.Name) {
  $value = $configMapObject.data.$key
  $envContent += "$key=`"$value`"`n"
}

# Sauvegarder le contenu dans le fichier .env
$envContent | Out-File -FilePath $outputFile -Encoding utf8

Write-Output $envContent
Write-Output "Content save to $outputFile"

$certificateJson = kubectl get secret $certificateName -n $namespace -o json
$certificateObject = $certificateJson | ConvertFrom-Json

foreach ($key in $certificateObject.data.PSObject.Properties.Name) {
  $value = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($certificateObject.data.$key))
  $value | Out-File -FilePath $key -Encoding utf8
  Write-Output "Content save to $key"
}









