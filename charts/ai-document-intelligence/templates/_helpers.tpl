{{/*
Expand the name of the chart.
*/}}
{{- define "ai-document-intelligence.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ai-document-intelligence.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ai-document-intelligence.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand the name of the default storage.
*/}}
{{- define "ai-document-intelligence.storageName" -}}
{{ include "ai-document-intelligence.fullname" . }}-storage
{{- end }}

{{/*
Expand the name of the nginx service.
*/}}
{{- define "ai-document-intelligence.nginxName" -}}
{{ include "ai-document-intelligence.fullname" . }}-nginx
{{- end }}

{{/*
Expand the name of the custom template service.
*/}}
{{- define "ai-document-intelligence.customTemplateName" -}}
{{ include "ai-document-intelligence.fullname" . }}-custom-template
{{- end }}

{{/*
Expand the name of the DI services shared persistent volume.
*/}}
{{- define "ai-document-intelligence.sharedVolumeName" -}}
{{ include "ai-document-intelligence.fullname" . }}-shared
{{- end }}

{{/*
Expand the name of the DI services output persistent volume.
*/}}
{{- define "ai-document-intelligence.outputVolumeName" -}}
{{ include "ai-document-intelligence.fullname" . }}-output
{{- end }}

{{/*
Expand the name of the layout service.
*/}}
{{- define "ai-document-intelligence.layoutName" -}}
{{ include "ai-document-intelligence.fullname" . }}-layout
{{- end }}

{{/*
Expand the host URL for the layout service.
*/}}
{{- define "ai-document-intelligence.layoutHost" -}}
http://{{ include "ai-document-intelligence.layoutName" . }}:{{ .Values.layout.port }}
{{- end }}

{{/*
Expand the name of the read service.
*/}}
{{- define "ai-document-intelligence.readName" -}}
{{ include "ai-document-intelligence.fullname" . }}-read
{{- end }}

{{/*
Expand the host URL for the read service.
*/}}
{{- define "ai-document-intelligence.readHost" -}}
http://{{ include "ai-document-intelligence.readName" . }}:{{ .Values.read.port }}
{{- end }}

{{/*
Expand the name of the id document service.
*/}}
{{- define "ai-document-intelligence.id-documentName" -}}
{{ include "ai-document-intelligence.fullname" . }}-id-document
{{- end }}

{{/*
Expand the name of the receipt service.
*/}}
{{- define "ai-document-intelligence.receiptName" -}}
{{ include "ai-document-intelligence.fullname" . }}-receipt
{{- end }}

{{/*
Expand the name of the invoice service.
*/}}
{{- define "ai-document-intelligence.invoiceName" -}}
{{ include "ai-document-intelligence.fullname" . }}-invoice
{{- end }}

{{/*
Expand the name of the studio service.
*/}}
{{- define "ai-document-intelligence.studioName" -}}
{{ include "ai-document-intelligence.fullname" . }}-studio
{{- end }}

{{/*
Expand the name of global FQDN
*/}}
{{- define "global.fqdn" -}}
{{ printf "%s.%s" "docintel" .Values.ingress.tlsDomain }}
{{- end }}

{{/*
Expand the name of the oidc FQDN
*/}}
{{- define "oidc.fqdn" -}}
{{ printf "%s.%s" "oidc" .Values.ingress.tlsDomain }}
{{- end }}

{{/*
Expand the name of the oauth2 FQDN
*/}}
{{- define "oauth2.fqdn" -}}
{{- if (not .Values.oauth2proxy.enable) }}{{.Values.oauth2proxy.existingFqdn}}{{- else}}{{ include "global.fqdn" .}}{{- end}}
{{- end}}

{{/*
Expand the name of the api custom template FQDN
*/}}
{{- define "api.customtemplate.fqdn" -}}
{{- printf "%s.%s" "api-customtemplate" .Values.ingress.tlsDomain }}
{{- end}}

{{/*
Expand the name of the api id FQDN
*/}}
{{- define "api.id.fqdn" -}}
{{- printf "%s.%s" "api-id" .Values.ingress.tlsDomain }}
{{- end}}

{{/*
Expand the name of the api invoice FQDN
*/}}
{{- define "api.invoice.fqdn" -}}
{{- printf "%s.%s" "api-invoice" .Values.ingress.tlsDomain }}
{{- end}}

{{/*
Expand the name of the api receipt FQDN
*/}}
{{- define "api.receipt.fqdn" -}}
{{- printf "%s.%s" "api-receipt" .Values.ingress.tlsDomain }}
{{- end}}

{{/*
Expand the name of the api read FQDN
*/}}
{{- define "api.read.fqdn" -}}
{{- printf "%s.%s" "api-read" .Values.ingress.tlsDomain }}
{{- end}}

{{/*
Expand the name of the api layout FQDN
*/}}
{{- define "api.layout.fqdn" -}}
{{- printf "%s.%s" "api-layout" .Values.ingress.tlsDomain }}
{{- end}}


{{/*
Expand the name of the studio file persistent volume.
*/}}
{{- define "ai-document-intelligence.studioFileVolumeName" -}}
{{ include "ai-document-intelligence.studioName" . }}-file
{{- end }}

{{/*
Expand the name of the studio database persistent volume.
*/}}
{{- define "ai-document-intelligence.studioDatabaseVolumeName" -}}
{{ include "ai-document-intelligence.studioName" . }}-database
{{- end }}

{{/*
Expand the name of the studio database file path.
*/}}
{{- define "ai-document-intelligence.studioDatabaseFilePath" -}}
{{ .Values.documentIntelligence.studioDatabaseFolder }}/Application.db
{{- end }}

{{/*
Common labels
*/}}
{{- define "ai-document-intelligence.labels" -}}
helm.sh/chart: {{ include "ai-document-intelligence.chart" . }}
{{ include "ai-document-intelligence.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ai-document-intelligence.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ai-document-intelligence.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
