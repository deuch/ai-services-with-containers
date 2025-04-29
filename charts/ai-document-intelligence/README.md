# Chart values reference

Please find references of all the values that can be used within the Chart  

## Values

### Custom template model container

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| customTemplate.enable | bool | `false` | Enable custom template deployment |
| customTemplate.image | string | `"mcr.microsoft.com/azure-cognitive-services/form-recognizer/custom-template-3.1:latest"` | Image for custom template deployment |
| customTemplate.ingress.maxPayloadSize | string | `"32m"` | max payload for ingress controller |
| customTemplate.port | int | `5000` | Port to listen |
| customTemplate.replicaCount | int | `1` | Number of replica for the pod |
| customTemplate.resources.limits.cpu | int | `8` | CPU limits for custom template deployment |
| customTemplate.resources.limits.memory | string | `"24Gi"` | Memory limits for custom template deployment |
| customTemplate.resources.requests.cpu | int | `4` | Cpu requests for custom template deployment |
| customTemplate.resources.requests.memory | string | `"8Gi"` | Memory requests for custom template deployment |

### Global Document Intelligence Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| documentIntelligence.logLevel | string | `"Information"` | To set the log level 'Debug, Information, Wargnin ...' |
| documentIntelligence.outputFolder | string | `"/logs"` | Logs folder |
| documentIntelligence.outputVolume.accessModes | list | `["ReadWriteMany"]` | Default Access Mode |
| documentIntelligence.outputVolume.capacity | string | `"1Gi"` | Default size of the volume |
| documentIntelligence.outputVolume.reclaimPolicy | string | `"Delete"` | Reclaim policy when deleting the volume |
| documentIntelligence.outputVolume.storageClassName | string | `"di-azurefile"` | Storage class for the output of the datas |
| documentIntelligence.secret | object | `{"apiKey":"apiKey","endpointKey":"endpoint","name":"docintel-secret"}` | Secret to store api key and endpoint of document intelligence instance |
| documentIntelligence.secret.apiKey | string | `"apiKey"` | Key Name to retrieve the apikey value in the secret |
| documentIntelligence.secret.endpointKey | string | `"endpoint"` | Key Name to retrieve the docintel endpoint value in the secret  |
| documentIntelligence.secret.name | string | `"docintel-secret"` | Name of the K8S Secret to store api key and endpoint of document intelligence instance |
| documentIntelligence.sharedRootFolder | string | `"/share"` | Path to share datas between containers |
| documentIntelligence.sharedVolume.accessModes | list | `["ReadWriteMany"]` | Default Access Mode |
| documentIntelligence.sharedVolume.capacity | string | `"1Gi"` | Default size of the volume |
| documentIntelligence.sharedVolume.reclaimPolicy | string | `"Delete"` | Reclaim policy when deleting the volume |
| documentIntelligence.sharedVolume.storageClassName | string | `"di-azurefile"` | Storage class name to use for the shared folder |
| documentIntelligence.studioDatabaseFolder | string | `"/onprem_db"` | Studio database folder path in the container |
| documentIntelligence.studioDatabaseVolume.accessModes | list | `["ReadWriteMany"]` | Default Access Mode |
| documentIntelligence.studioDatabaseVolume.capacity | string | `"1Gi"` | Default size of the volume |
| documentIntelligence.studioDatabaseVolume.reclaimPolicy | string | `"Delete"` | Reclaim policy when deleting the volume |
| documentIntelligence.studioDatabaseVolume.storageClassName | string | `"di-azurefile"` | Storage class name to use for the studio DB |
| documentIntelligence.studioFileFolder | string | `"/onprem_folder"` | Studio folder path in the container |
| documentIntelligence.studioFileVolume.accessModes | list | `["ReadWriteMany"]` | Default Access Mode |
| documentIntelligence.studioFileVolume.capacity | string | `"1Gi"` | Default size of the volume |
| documentIntelligence.studioFileVolume.reclaimPolicy | string | `"Delete"` | Reclaim policy when deleting the volume |
| documentIntelligence.studioFileVolume.storageClassName | string | `"di-azurefile"` | Storage class name to use for the studio |

### ID Document model container

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| iddocument.enable | bool | `true` | Enable iddocument template deployment |
| iddocument.image | string | `"mcr.microsoft.com/azure-cognitive-services/form-recognizer/id-document-3.1:latest"` | Image for iddocument template deployment |
| iddocument.ingress.maxPayloadSize | string | `"32m"` | max payload for ingress controller |
| iddocument.port | int | `5050` | Port to listen |
| iddocument.replicaCount | int | `1` | Number of replica for the pod |
| iddocument.resources.limits.cpu | int | `8` | CPU limits for iddocument template deployment |
| iddocument.resources.limits.memory | string | `"24Gi"` | Memory limits for iddocument template deployment |
| iddocument.resources.requests.cpu | int | `4` | Cpu requests for iddocument template deployment |
| iddocument.resources.requests.memory | string | `"8Gi"` | Memory requests for iddocument template deployment |

### Configuration of the nginx ingress controller

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress-nginx.controller.allowSnippetAnnotations | string | `"true"` | Enable the usage of snippet in nginx configuration |
| ingress-nginx.controller.config | object | `{"annotations-risk-level":"Critical","http-snippet":"map $upstream_http_operation_location $m_replaceme {\n\"\" \"\";\n\"~^http://(.*)$\" \"https://$1\";\n}\n","map-hash-bucket-size":"128"}` | Add on to the nginx configmap. Use to modify the api answer to ensure https |
| ingress-nginx.controller.podAnnotations."linkerd.io/inject" | string | `"enabled"` | Linkerd injection |
| ingress-nginx.controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" | string | `"/healthz"` | Path for health check  |
| ingress-nginx.controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-internal" | string | `"true"` | Internal or External load balancer  |
| ingress-nginx.enable | bool | `true` | Enable the installation of nginx ingress controller |

### Ingress domain and secret configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.autoGenerate | bool | `true` | Autogeneration of the HTTPS certificates with custom RootCA |
| ingress.existingSecret | string | `nil` | If using existing secret, please set the name. ingress.autoGenerate must be set to false |
| ingress.existingSecretNamespace | string | `nil` | If using existing secret, please set the namespace where the secret was created. A copy will be made. ingress.autoGenerate must be set to false |
| ingress.maxPayloadSize | string | `"32m"` | max payload for ingress controller (global) |
| ingress.tls.certificate | string | `nil` | If you provide your own certificate file , set the file name which hold the certificate. ingress.autoGenerate must be set to false |
| ingress.tls.key | string | `nil` | If you provide your own certificate file, set the file name which hold the key. ingress.autoGenerate must be set to false |
| ingress.tlsDomain | string | `"aiservices.com"` | Domain used for all FQDN of the services |
| ingress.tlsSecret | string | `"tls-ingress-secret"` | Secret to store the HTTPS certificates |

### Invoice model container

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| invoice.enable | bool | `false` | Enable invoice template deployment |
| invoice.image | string | `"mcr.microsoft.com/azure-cognitive-services/form-recognizer/invoice-3.1:latest"` | Image for invoice template deployment |
| invoice.ingress.maxPayloadSize | string | `"32m"` | max payload for ingress controller |
| invoice.port | int | `5050` | Port to listen |
| invoice.replicaCount | int | `1` | Number of replica for the pod |
| invoice.resources.limits.cpu | int | `8` | CPU limits for invoice template deployment |
| invoice.resources.limits.memory | string | `"24Gi"` | Memory limits for invoice template deployment |
| invoice.resources.requests.cpu | int | `4` | Cpu requests for invoice template deployment |
| invoice.resources.requests.memory | string | `"8Gi"` | Memory requests for invoice template deployment |

### Layout model container

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| layout.enable | bool | `true` | Enable layout template deployment |
| layout.image | string | `"mcr.microsoft.com/azure-cognitive-services/form-recognizer/layout-3.1:latest"` | Image for layout template deployment |
| layout.ingress.maxPayloadSize | string | `"32m"` | max payload for ingress controller |
| layout.port | int | `5000` | Port to listen |
| layout.replicaCount | int | `1` | Number of replica for the pod |
| layout.resources.limits.cpu | int | `8` | CPU limits for layout template deployment |
| layout.resources.limits.memory | string | `"24Gi"` | Memory limits for layout template deployment |
| layout.resources.requests.cpu | int | `4` | Cpu requests for layout template deployment |
| layout.resources.requests.memory | string | `"8Gi"` | Memory requests for layout template deployment |

### Linkerd injection

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| linkerd.injection | string | `"enabled"` | Enable linkerd sidecar injection |

### Oauth2-proxy configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| oauth2proxy.emailDomain | string | `"*"` | Email domain to use (let to *) |
| oauth2proxy.enable | bool | `true` | Enable installation of oauth2proxy |
| oauth2proxy.existingFqdn | string | `nil` | if an existing oauth2proxy instance exist, please use the associated FQDN. oauth2proxy.enable must be set to false |
| oauth2proxy.image | string | `"quay.io/oauth2-proxy/oauth2-proxy:latest"` | Repository and image name for oauth2 proxy |
| oauth2proxy.name | string | `"oauth2-proxy"` | Name of oauth2proxy deployment |
| oauth2proxy.oauth2Secret.clientIdKey | string | `"OAUTH2_PROXY_CLIENT_ID"` | Name of the clientId key. You need to pass the value in command line |
| oauth2proxy.oauth2Secret.clientSecretKey | string | `"OAUTH2_PROXY_CLIENT_SECRET"` | Name of the clientSecret key. You need to pass the value in command line |
| oauth2proxy.oauth2Secret.cookieSecretKey | string | `"OAUTH2_PROXY_COOKIE_SECRET"` | Name of the cookieSecret key. You need to pass the value in command line |
| oauth2proxy.oauth2Secret.name | string | `"oauth2-proxy-secrets"` | Name of the kubernetes secret |
| oauth2proxy.provider | string | `"oidc"` | Set the provider type. OIDC by default |
| oauth2proxy.scope | string | `"openid profile email"` | List of scope to check |
| oauth2proxy.skipJwt | string | `"true"` | Use the bearer token in the request (for API calls) |

### mini-oidc configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| oidc.enable | bool | `true` | Enable installation of mini-oidc |
| oidc.image | string | `"aiservicesprivate.azurecr.io/mini-oidc:1.0"` | mini-oidc image |
| oidc.name | string | `"mini-oidc"` | mini-oidc deployment name |
| oidc.port | int | `8000` | mini-oidc port |
| oidc.replicaCount | int | `1` | mini-oidc pods replicas |
| oidc.resources.limits.cpu | int | `1` | CPU limits for mini-oidc deployment |
| oidc.resources.limits.memory | string | `"1Gi"` | CPU limits for mini-oidc deployment |
| oidc.resources.requests.cpu | int | `1` | CPU requests for mini-oidc deployment |
| oidc.resources.requests.memory | string | `"1Gi"` | CPU requests for mini-oidc deployment |
| oidc.userName | string | `"user"` | username for the default user |

### Read model container

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| read.enable | bool | `true` | Enable iddocument template deployment |
| read.image | string | `"mcr.microsoft.com/azure-cognitive-services/form-recognizer/read-3.1:latest"` | Image for iddocument template deployment |
| read.ingress.maxPayloadSize | string | `"32m"` | max payload for ingress controller |
| read.port | int | `5000` | Port to listen |
| read.replicaCount | int | `1` | Number of replica for the pod |
| read.resources.limits.cpu | int | `8` | CPU limits for iddocument template deployment |
| read.resources.limits.memory | string | `"24Gi"` | Memory limits for iddocument template deployment |
| read.resources.requests.cpu | int | `4` | Cpu requests for iddocument template deployment |
| read.resources.requests.memory | string | `"8Gi"` | Memory requests for iddocument template deployment |

### Receipt model container

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| receipt.enable | bool | `true` | Enable receipt template deployment |
| receipt.image | string | `"mcr.microsoft.com/azure-cognitive-services/form-recognizer/receipt-3.1:latest"` | Image for receipt template deployment |
| receipt.ingress.maxPayloadSize | string | `"32m"` | max payload for ingress controller |
| receipt.port | int | `5050` | Port to listen |
| receipt.replicaCount | int | `1` | Number of replica for the pod |
| receipt.resources.limits.cpu | int | `8` | CPU limits for receipt template deployment |
| receipt.resources.limits.memory | string | `"24Gi"` | Memory limits for receipt template deployment |
| receipt.resources.requests.cpu | int | `4` | Cpu requests for receipt template deployment |
| receipt.resources.requests.memory | string | `"8Gi"` | Memory requests for receipt template deployment |

### Studio container

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| studio.enable | bool | `true` | Enable studio template deployment |
| studio.image | string | `"mcr.microsoft.com/azure-cognitive-services/form-recognizer/studio-3.1:latest"` | Image for studio template deployment |
| studio.ingress.maxPayloadSize | string | `"32m"` | max payload for ingress controller |
| studio.port | int | `5001` | Port to listen |
| studio.replicaCount | int | `1` | Number of replica for the pod |
| studio.resources.limits.cpu | int | `4` | CPU limits for studio template deployment |
| studio.resources.limits.memory | string | `"8Gi"` | Memory limits for studio template deployment |
| studio.resources.requests.cpu | int | `2` | Cpu requests for studio template deployment |
| studio.resources.requests.memory | string | `"4Gi"` | Memory requests for studio template deployment |

### Other Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| documentIntelligence.env | object | `{}` |  |
| documentIntelligence.outputVolume.variables | object | `{}` |  |
| documentIntelligence.sharedVolume.variables | object | `{}` |  |
| documentIntelligence.studioDatabaseVolume.variables | object | `{}` |  |
| documentIntelligence.studioFileVolume.variables | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| nameOverride | string | `""` |  |
| storageClassName | string | `"di-azurefile"` | Storage Class Name |


## Values

<h3>Custom template model container</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>customTemplate.enable</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable custom template deployment</td>
		</tr>
		<tr>
			<td>customTemplate.image</td>
			<td>string</td>
			<td><pre lang="json">
"mcr.microsoft.com/azure-cognitive-services/form-recognizer/custom-template-3.1:latest"
</pre>
</td>
			<td>Image for custom template deployment</td>
		</tr>
		<tr>
			<td>customTemplate.ingress.maxPayloadSize</td>
			<td>string</td>
			<td><pre lang="json">
"32m"
</pre>
</td>
			<td>max payload for ingress controller</td>
		</tr>
		<tr>
			<td>customTemplate.port</td>
			<td>int</td>
			<td><pre lang="json">
5000
</pre>
</td>
			<td>Port to listen</td>
		</tr>
		<tr>
			<td>customTemplate.replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Number of replica for the pod</td>
		</tr>
		<tr>
			<td>customTemplate.resources.limits.cpu</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>CPU limits for custom template deployment</td>
		</tr>
		<tr>
			<td>customTemplate.resources.limits.memory</td>
			<td>string</td>
			<td><pre lang="json">
"24Gi"
</pre>
</td>
			<td>Memory limits for custom template deployment</td>
		</tr>
		<tr>
			<td>customTemplate.resources.requests.cpu</td>
			<td>int</td>
			<td><pre lang="json">
4
</pre>
</td>
			<td>Cpu requests for custom template deployment</td>
		</tr>
		<tr>
			<td>customTemplate.resources.requests.memory</td>
			<td>string</td>
			<td><pre lang="json">
"8Gi"
</pre>
</td>
			<td>Memory requests for custom template deployment</td>
		</tr>
	</tbody>
</table>
<h3>Global Document Intelligence Parameters</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>documentIntelligence.logLevel</td>
			<td>string</td>
			<td><pre lang="json">
"Information"
</pre>
</td>
			<td>To set the log level 'Debug, Information, Wargnin ...'</td>
		</tr>
		<tr>
			<td>documentIntelligence.outputFolder</td>
			<td>string</td>
			<td><pre lang="json">
"/logs"
</pre>
</td>
			<td>Logs folder</td>
		</tr>
		<tr>
			<td>documentIntelligence.outputVolume.accessModes</td>
			<td>list</td>
			<td><pre lang="json">
[
  "ReadWriteMany"
]
</pre>
</td>
			<td>Default Access Mode</td>
		</tr>
		<tr>
			<td>documentIntelligence.outputVolume.capacity</td>
			<td>string</td>
			<td><pre lang="json">
"1Gi"
</pre>
</td>
			<td>Default size of the volume</td>
		</tr>
		<tr>
			<td>documentIntelligence.outputVolume.reclaimPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"Delete"
</pre>
</td>
			<td>Reclaim policy when deleting the volume</td>
		</tr>
		<tr>
			<td>documentIntelligence.outputVolume.storageClassName</td>
			<td>string</td>
			<td><pre lang="json">
"di-azurefile"
</pre>
</td>
			<td>Storage class for the output of the datas</td>
		</tr>
		<tr>
			<td>documentIntelligence.secret</td>
			<td>object</td>
			<td><pre lang="json">
{
  "apiKey": "apiKey",
  "endpointKey": "endpoint",
  "name": "docintel-secret"
}
</pre>
</td>
			<td>Secret to store api key and endpoint of document intelligence instance</td>
		</tr>
		<tr>
			<td>documentIntelligence.secret.apiKey</td>
			<td>string</td>
			<td><pre lang="json">
"apiKey"
</pre>
</td>
			<td>Key Name to retrieve the apikey value in the secret</td>
		</tr>
		<tr>
			<td>documentIntelligence.secret.endpointKey</td>
			<td>string</td>
			<td><pre lang="json">
"endpoint"
</pre>
</td>
			<td>Key Name to retrieve the docintel endpoint value in the secret </td>
		</tr>
		<tr>
			<td>documentIntelligence.secret.name</td>
			<td>string</td>
			<td><pre lang="json">
"docintel-secret"
</pre>
</td>
			<td>Name of the K8S Secret to store api key and endpoint of document intelligence instance</td>
		</tr>
		<tr>
			<td>documentIntelligence.sharedRootFolder</td>
			<td>string</td>
			<td><pre lang="json">
"/share"
</pre>
</td>
			<td>Path to share datas between containers</td>
		</tr>
		<tr>
			<td>documentIntelligence.sharedVolume.accessModes</td>
			<td>list</td>
			<td><pre lang="json">
[
  "ReadWriteMany"
]
</pre>
</td>
			<td>Default Access Mode</td>
		</tr>
		<tr>
			<td>documentIntelligence.sharedVolume.capacity</td>
			<td>string</td>
			<td><pre lang="json">
"1Gi"
</pre>
</td>
			<td>Default size of the volume</td>
		</tr>
		<tr>
			<td>documentIntelligence.sharedVolume.reclaimPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"Delete"
</pre>
</td>
			<td>Reclaim policy when deleting the volume</td>
		</tr>
		<tr>
			<td>documentIntelligence.sharedVolume.storageClassName</td>
			<td>string</td>
			<td><pre lang="json">
"di-azurefile"
</pre>
</td>
			<td>Storage class name to use for the shared folder</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioDatabaseFolder</td>
			<td>string</td>
			<td><pre lang="json">
"/onprem_db"
</pre>
</td>
			<td>Studio database folder path in the container</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioDatabaseVolume.accessModes</td>
			<td>list</td>
			<td><pre lang="json">
[
  "ReadWriteMany"
]
</pre>
</td>
			<td>Default Access Mode</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioDatabaseVolume.capacity</td>
			<td>string</td>
			<td><pre lang="json">
"1Gi"
</pre>
</td>
			<td>Default size of the volume</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioDatabaseVolume.reclaimPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"Delete"
</pre>
</td>
			<td>Reclaim policy when deleting the volume</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioDatabaseVolume.storageClassName</td>
			<td>string</td>
			<td><pre lang="json">
"di-azurefile"
</pre>
</td>
			<td>Storage class name to use for the studio DB</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioFileFolder</td>
			<td>string</td>
			<td><pre lang="json">
"/onprem_folder"
</pre>
</td>
			<td>Studio folder path in the container</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioFileVolume.accessModes</td>
			<td>list</td>
			<td><pre lang="json">
[
  "ReadWriteMany"
]
</pre>
</td>
			<td>Default Access Mode</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioFileVolume.capacity</td>
			<td>string</td>
			<td><pre lang="json">
"1Gi"
</pre>
</td>
			<td>Default size of the volume</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioFileVolume.reclaimPolicy</td>
			<td>string</td>
			<td><pre lang="json">
"Delete"
</pre>
</td>
			<td>Reclaim policy when deleting the volume</td>
		</tr>
		<tr>
			<td>documentIntelligence.studioFileVolume.storageClassName</td>
			<td>string</td>
			<td><pre lang="json">
"di-azurefile"
</pre>
</td>
			<td>Storage class name to use for the studio</td>
		</tr>
	</tbody>
</table>
<h3>ID Document model container</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>iddocument.enable</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable iddocument template deployment</td>
		</tr>
		<tr>
			<td>iddocument.image</td>
			<td>string</td>
			<td><pre lang="json">
"mcr.microsoft.com/azure-cognitive-services/form-recognizer/id-document-3.1:latest"
</pre>
</td>
			<td>Image for iddocument template deployment</td>
		</tr>
		<tr>
			<td>iddocument.ingress.maxPayloadSize</td>
			<td>string</td>
			<td><pre lang="json">
"32m"
</pre>
</td>
			<td>max payload for ingress controller</td>
		</tr>
		<tr>
			<td>iddocument.port</td>
			<td>int</td>
			<td><pre lang="json">
5050
</pre>
</td>
			<td>Port to listen</td>
		</tr>
		<tr>
			<td>iddocument.replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Number of replica for the pod</td>
		</tr>
		<tr>
			<td>iddocument.resources.limits.cpu</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>CPU limits for iddocument template deployment</td>
		</tr>
		<tr>
			<td>iddocument.resources.limits.memory</td>
			<td>string</td>
			<td><pre lang="json">
"24Gi"
</pre>
</td>
			<td>Memory limits for iddocument template deployment</td>
		</tr>
		<tr>
			<td>iddocument.resources.requests.cpu</td>
			<td>int</td>
			<td><pre lang="json">
4
</pre>
</td>
			<td>Cpu requests for iddocument template deployment</td>
		</tr>
		<tr>
			<td>iddocument.resources.requests.memory</td>
			<td>string</td>
			<td><pre lang="json">
"8Gi"
</pre>
</td>
			<td>Memory requests for iddocument template deployment</td>
		</tr>
	</tbody>
</table>
<h3>Configuration of the nginx ingress controller</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>ingress-nginx.controller.allowSnippetAnnotations</td>
			<td>string</td>
			<td><pre lang="json">
"true"
</pre>
</td>
			<td>Enable the usage of snippet in nginx configuration</td>
		</tr>
		<tr>
			<td>ingress-nginx.controller.config</td>
			<td>object</td>
			<td><pre lang="json">
{
  "annotations-risk-level": "Critical",
  "http-snippet": "map $upstream_http_operation_location $m_replaceme {\n\"\" \"\";\n\"~^http://(.*)$\" \"https://$1\";\n}\n",
  "map-hash-bucket-size": "128"
}
</pre>
</td>
			<td>Add on to the nginx configmap. Use to modify the api answer to ensure https</td>
		</tr>
		<tr>
			<td>ingress-nginx.controller.podAnnotations."linkerd.io/inject"</td>
			<td>string</td>
			<td><pre lang="json">
"enabled"
</pre>
</td>
			<td>Linkerd injection</td>
		</tr>
		<tr>
			<td>ingress-nginx.controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path"</td>
			<td>string</td>
			<td><pre lang="json">
"/healthz"
</pre>
</td>
			<td>Path for health check </td>
		</tr>
		<tr>
			<td>ingress-nginx.controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-internal"</td>
			<td>string</td>
			<td><pre lang="json">
"true"
</pre>
</td>
			<td>Internal or External load balancer </td>
		</tr>
		<tr>
			<td>ingress-nginx.enable</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable the installation of nginx ingress controller</td>
		</tr>
	</tbody>
</table>
<h3>Ingress domain and secret configuration</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>ingress.autoGenerate</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Autogeneration of the HTTPS certificates with custom RootCA</td>
		</tr>
		<tr>
			<td>ingress.existingSecret</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>If using existing secret, please set the name. ingress.autoGenerate must be set to false</td>
		</tr>
		<tr>
			<td>ingress.existingSecretNamespace</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>If using existing secret, please set the namespace where the secret was created. A copy will be made. ingress.autoGenerate must be set to false</td>
		</tr>
		<tr>
			<td>ingress.maxPayloadSize</td>
			<td>string</td>
			<td><pre lang="json">
"32m"
</pre>
</td>
			<td>max payload for ingress controller (global)</td>
		</tr>
		<tr>
			<td>ingress.tls.certificate</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>If you provide your own certificate file , set the file name which hold the certificate. ingress.autoGenerate must be set to false</td>
		</tr>
		<tr>
			<td>ingress.tls.key</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>If you provide your own certificate file, set the file name which hold the key. ingress.autoGenerate must be set to false</td>
		</tr>
		<tr>
			<td>ingress.tlsDomain</td>
			<td>string</td>
			<td><pre lang="json">
"aiservices.com"
</pre>
</td>
			<td>Domain used for all FQDN of the services</td>
		</tr>
		<tr>
			<td>ingress.tlsSecret</td>
			<td>string</td>
			<td><pre lang="json">
"tls-ingress-secret"
</pre>
</td>
			<td>Secret to store the HTTPS certificates</td>
		</tr>
	</tbody>
</table>
<h3>Invoice model container</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>invoice.enable</td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre>
</td>
			<td>Enable invoice template deployment</td>
		</tr>
		<tr>
			<td>invoice.image</td>
			<td>string</td>
			<td><pre lang="json">
"mcr.microsoft.com/azure-cognitive-services/form-recognizer/invoice-3.1:latest"
</pre>
</td>
			<td>Image for invoice template deployment</td>
		</tr>
		<tr>
			<td>invoice.ingress.maxPayloadSize</td>
			<td>string</td>
			<td><pre lang="json">
"32m"
</pre>
</td>
			<td>max payload for ingress controller</td>
		</tr>
		<tr>
			<td>invoice.port</td>
			<td>int</td>
			<td><pre lang="json">
5050
</pre>
</td>
			<td>Port to listen</td>
		</tr>
		<tr>
			<td>invoice.replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Number of replica for the pod</td>
		</tr>
		<tr>
			<td>invoice.resources.limits.cpu</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>CPU limits for invoice template deployment</td>
		</tr>
		<tr>
			<td>invoice.resources.limits.memory</td>
			<td>string</td>
			<td><pre lang="json">
"24Gi"
</pre>
</td>
			<td>Memory limits for invoice template deployment</td>
		</tr>
		<tr>
			<td>invoice.resources.requests.cpu</td>
			<td>int</td>
			<td><pre lang="json">
4
</pre>
</td>
			<td>Cpu requests for invoice template deployment</td>
		</tr>
		<tr>
			<td>invoice.resources.requests.memory</td>
			<td>string</td>
			<td><pre lang="json">
"8Gi"
</pre>
</td>
			<td>Memory requests for invoice template deployment</td>
		</tr>
	</tbody>
</table>
<h3>Layout model container</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>layout.enable</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable layout template deployment</td>
		</tr>
		<tr>
			<td>layout.image</td>
			<td>string</td>
			<td><pre lang="json">
"mcr.microsoft.com/azure-cognitive-services/form-recognizer/layout-3.1:latest"
</pre>
</td>
			<td>Image for layout template deployment</td>
		</tr>
		<tr>
			<td>layout.ingress.maxPayloadSize</td>
			<td>string</td>
			<td><pre lang="json">
"32m"
</pre>
</td>
			<td>max payload for ingress controller</td>
		</tr>
		<tr>
			<td>layout.port</td>
			<td>int</td>
			<td><pre lang="json">
5000
</pre>
</td>
			<td>Port to listen</td>
		</tr>
		<tr>
			<td>layout.replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Number of replica for the pod</td>
		</tr>
		<tr>
			<td>layout.resources.limits.cpu</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>CPU limits for layout template deployment</td>
		</tr>
		<tr>
			<td>layout.resources.limits.memory</td>
			<td>string</td>
			<td><pre lang="json">
"24Gi"
</pre>
</td>
			<td>Memory limits for layout template deployment</td>
		</tr>
		<tr>
			<td>layout.resources.requests.cpu</td>
			<td>int</td>
			<td><pre lang="json">
4
</pre>
</td>
			<td>Cpu requests for layout template deployment</td>
		</tr>
		<tr>
			<td>layout.resources.requests.memory</td>
			<td>string</td>
			<td><pre lang="json">
"8Gi"
</pre>
</td>
			<td>Memory requests for layout template deployment</td>
		</tr>
	</tbody>
</table>
<h3>Linkerd injection</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>linkerd.injection</td>
			<td>string</td>
			<td><pre lang="json">
"enabled"
</pre>
</td>
			<td>Enable linkerd sidecar injection</td>
		</tr>
	</tbody>
</table>
<h3>Oauth2-proxy configuration</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>oauth2proxy.emailDomain</td>
			<td>string</td>
			<td><pre lang="json">
"*"
</pre>
</td>
			<td>Email domain to use (let to *)</td>
		</tr>
		<tr>
			<td>oauth2proxy.enable</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable installation of oauth2proxy</td>
		</tr>
		<tr>
			<td>oauth2proxy.existingFqdn</td>
			<td>string</td>
			<td><pre lang="json">
null
</pre>
</td>
			<td>if an existing oauth2proxy instance exist, please use the associated FQDN. oauth2proxy.enable must be set to false</td>
		</tr>
		<tr>
			<td>oauth2proxy.image</td>
			<td>string</td>
			<td><pre lang="json">
"quay.io/oauth2-proxy/oauth2-proxy:latest"
</pre>
</td>
			<td>Repository and image name for oauth2 proxy</td>
		</tr>
		<tr>
			<td>oauth2proxy.name</td>
			<td>string</td>
			<td><pre lang="json">
"oauth2-proxy"
</pre>
</td>
			<td>Name of oauth2proxy deployment</td>
		</tr>
		<tr>
			<td>oauth2proxy.oauth2Secret.clientIdKey</td>
			<td>string</td>
			<td><pre lang="json">
"OAUTH2_PROXY_CLIENT_ID"
</pre>
</td>
			<td>Name of the clientId key. You need to pass the value in command line</td>
		</tr>
		<tr>
			<td>oauth2proxy.oauth2Secret.clientSecretKey</td>
			<td>string</td>
			<td><pre lang="json">
"OAUTH2_PROXY_CLIENT_SECRET"
</pre>
</td>
			<td>Name of the clientSecret key. You need to pass the value in command line</td>
		</tr>
		<tr>
			<td>oauth2proxy.oauth2Secret.cookieSecretKey</td>
			<td>string</td>
			<td><pre lang="json">
"OAUTH2_PROXY_COOKIE_SECRET"
</pre>
</td>
			<td>Name of the cookieSecret key. You need to pass the value in command line</td>
		</tr>
		<tr>
			<td>oauth2proxy.oauth2Secret.name</td>
			<td>string</td>
			<td><pre lang="json">
"oauth2-proxy-secrets"
</pre>
</td>
			<td>Name of the kubernetes secret</td>
		</tr>
		<tr>
			<td>oauth2proxy.provider</td>
			<td>string</td>
			<td><pre lang="json">
"oidc"
</pre>
</td>
			<td>Set the provider type. OIDC by default</td>
		</tr>
		<tr>
			<td>oauth2proxy.scope</td>
			<td>string</td>
			<td><pre lang="json">
"openid profile email"
</pre>
</td>
			<td>List of scope to check</td>
		</tr>
		<tr>
			<td>oauth2proxy.skipJwt</td>
			<td>string</td>
			<td><pre lang="json">
"true"
</pre>
</td>
			<td>Use the bearer token in the request (for API calls)</td>
		</tr>
	</tbody>
</table>
<h3>mini-oidc configuration</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>oidc.enable</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable installation of mini-oidc</td>
		</tr>
		<tr>
			<td>oidc.image</td>
			<td>string</td>
			<td><pre lang="json">
"aiservicesprivate.azurecr.io/mini-oidc:1.0"
</pre>
</td>
			<td>mini-oidc image</td>
		</tr>
		<tr>
			<td>oidc.name</td>
			<td>string</td>
			<td><pre lang="json">
"mini-oidc"
</pre>
</td>
			<td>mini-oidc deployment name</td>
		</tr>
		<tr>
			<td>oidc.port</td>
			<td>int</td>
			<td><pre lang="json">
8000
</pre>
</td>
			<td>mini-oidc port</td>
		</tr>
		<tr>
			<td>oidc.replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>mini-oidc pods replicas</td>
		</tr>
		<tr>
			<td>oidc.resources.limits.cpu</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>CPU limits for mini-oidc deployment</td>
		</tr>
		<tr>
			<td>oidc.resources.limits.memory</td>
			<td>string</td>
			<td><pre lang="json">
"1Gi"
</pre>
</td>
			<td>CPU limits for mini-oidc deployment</td>
		</tr>
		<tr>
			<td>oidc.resources.requests.cpu</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>CPU requests for mini-oidc deployment</td>
		</tr>
		<tr>
			<td>oidc.resources.requests.memory</td>
			<td>string</td>
			<td><pre lang="json">
"1Gi"
</pre>
</td>
			<td>CPU requests for mini-oidc deployment</td>
		</tr>
		<tr>
			<td>oidc.userName</td>
			<td>string</td>
			<td><pre lang="json">
"user"
</pre>
</td>
			<td>username for the default user</td>
		</tr>
	</tbody>
</table>
<h3>Read model container</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>read.enable</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable iddocument template deployment</td>
		</tr>
		<tr>
			<td>read.image</td>
			<td>string</td>
			<td><pre lang="json">
"mcr.microsoft.com/azure-cognitive-services/form-recognizer/read-3.1:latest"
</pre>
</td>
			<td>Image for iddocument template deployment</td>
		</tr>
		<tr>
			<td>read.ingress.maxPayloadSize</td>
			<td>string</td>
			<td><pre lang="json">
"32m"
</pre>
</td>
			<td>max payload for ingress controller</td>
		</tr>
		<tr>
			<td>read.port</td>
			<td>int</td>
			<td><pre lang="json">
5000
</pre>
</td>
			<td>Port to listen</td>
		</tr>
		<tr>
			<td>read.replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Number of replica for the pod</td>
		</tr>
		<tr>
			<td>read.resources.limits.cpu</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>CPU limits for iddocument template deployment</td>
		</tr>
		<tr>
			<td>read.resources.limits.memory</td>
			<td>string</td>
			<td><pre lang="json">
"24Gi"
</pre>
</td>
			<td>Memory limits for iddocument template deployment</td>
		</tr>
		<tr>
			<td>read.resources.requests.cpu</td>
			<td>int</td>
			<td><pre lang="json">
4
</pre>
</td>
			<td>Cpu requests for iddocument template deployment</td>
		</tr>
		<tr>
			<td>read.resources.requests.memory</td>
			<td>string</td>
			<td><pre lang="json">
"8Gi"
</pre>
</td>
			<td>Memory requests for iddocument template deployment</td>
		</tr>
	</tbody>
</table>
<h3>Receipt model container</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>receipt.enable</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable receipt template deployment</td>
		</tr>
		<tr>
			<td>receipt.image</td>
			<td>string</td>
			<td><pre lang="json">
"mcr.microsoft.com/azure-cognitive-services/form-recognizer/receipt-3.1:latest"
</pre>
</td>
			<td>Image for receipt template deployment</td>
		</tr>
		<tr>
			<td>receipt.ingress.maxPayloadSize</td>
			<td>string</td>
			<td><pre lang="json">
"32m"
</pre>
</td>
			<td>max payload for ingress controller</td>
		</tr>
		<tr>
			<td>receipt.port</td>
			<td>int</td>
			<td><pre lang="json">
5050
</pre>
</td>
			<td>Port to listen</td>
		</tr>
		<tr>
			<td>receipt.replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Number of replica for the pod</td>
		</tr>
		<tr>
			<td>receipt.resources.limits.cpu</td>
			<td>int</td>
			<td><pre lang="json">
8
</pre>
</td>
			<td>CPU limits for receipt template deployment</td>
		</tr>
		<tr>
			<td>receipt.resources.limits.memory</td>
			<td>string</td>
			<td><pre lang="json">
"24Gi"
</pre>
</td>
			<td>Memory limits for receipt template deployment</td>
		</tr>
		<tr>
			<td>receipt.resources.requests.cpu</td>
			<td>int</td>
			<td><pre lang="json">
4
</pre>
</td>
			<td>Cpu requests for receipt template deployment</td>
		</tr>
		<tr>
			<td>receipt.resources.requests.memory</td>
			<td>string</td>
			<td><pre lang="json">
"8Gi"
</pre>
</td>
			<td>Memory requests for receipt template deployment</td>
		</tr>
	</tbody>
</table>
<h3>Studio container</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td>studio.enable</td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre>
</td>
			<td>Enable studio template deployment</td>
		</tr>
		<tr>
			<td>studio.image</td>
			<td>string</td>
			<td><pre lang="json">
"mcr.microsoft.com/azure-cognitive-services/form-recognizer/studio-3.1:latest"
</pre>
</td>
			<td>Image for studio template deployment</td>
		</tr>
		<tr>
			<td>studio.ingress.maxPayloadSize</td>
			<td>string</td>
			<td><pre lang="json">
"32m"
</pre>
</td>
			<td>max payload for ingress controller</td>
		</tr>
		<tr>
			<td>studio.port</td>
			<td>int</td>
			<td><pre lang="json">
5001
</pre>
</td>
			<td>Port to listen</td>
		</tr>
		<tr>
			<td>studio.replicaCount</td>
			<td>int</td>
			<td><pre lang="json">
1
</pre>
</td>
			<td>Number of replica for the pod</td>
		</tr>
		<tr>
			<td>studio.resources.limits.cpu</td>
			<td>int</td>
			<td><pre lang="json">
4
</pre>
</td>
			<td>CPU limits for studio template deployment</td>
		</tr>
		<tr>
			<td>studio.resources.limits.memory</td>
			<td>string</td>
			<td><pre lang="json">
"8Gi"
</pre>
</td>
			<td>Memory limits for studio template deployment</td>
		</tr>
		<tr>
			<td>studio.resources.requests.cpu</td>
			<td>int</td>
			<td><pre lang="json">
2
</pre>
</td>
			<td>Cpu requests for studio template deployment</td>
		</tr>
		<tr>
			<td>studio.resources.requests.memory</td>
			<td>string</td>
			<td><pre lang="json">
"4Gi"
</pre>
</td>
			<td>Memory requests for studio template deployment</td>
		</tr>
	</tbody>
</table>

<h3>Other Values</h3>
<table>
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
	<tr>
		<td>documentIntelligence.env</td>
		<td>object</td>
		<td><pre lang="json">
{}
</pre>
</td>
		<td></td>
	</tr>
	<tr>
		<td>documentIntelligence.outputVolume.variables</td>
		<td>object</td>
		<td><pre lang="json">
{}
</pre>
</td>
		<td></td>
	</tr>
	<tr>
		<td>documentIntelligence.sharedVolume.variables</td>
		<td>object</td>
		<td><pre lang="json">
{}
</pre>
</td>
		<td></td>
	</tr>
	<tr>
		<td>documentIntelligence.studioDatabaseVolume.variables</td>
		<td>object</td>
		<td><pre lang="json">
{}
</pre>
</td>
		<td></td>
	</tr>
	<tr>
		<td>documentIntelligence.studioFileVolume.variables</td>
		<td>object</td>
		<td><pre lang="json">
{}
</pre>
</td>
		<td></td>
	</tr>
	<tr>
		<td>fullnameOverride</td>
		<td>string</td>
		<td><pre lang="json">
""
</pre>
</td>
		<td></td>
	</tr>
	<tr>
		<td>nameOverride</td>
		<td>string</td>
		<td><pre lang="json">
""
</pre>
</td>
		<td></td>
	</tr>
	<tr>
		<td>storageClassName</td>
		<td>string</td>
		<td><pre lang="json">
"di-azurefile"
</pre>
</td>
		<td>Storage Class Name</td>
	</tr>
	</tbody>
</table>

