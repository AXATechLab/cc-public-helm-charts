{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "argocd-applications.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "argocd-applications.labels" -}}
helm.sh/chart: {{ include "argocd-applications.chart" . }}
{{- if .Chart.Version }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/environment-name: {{ include "argocd-applications.environmentName" . }}
{{- end }}

{{- define "argocd-applications.environmentName" }}
{{- $environmentName := "default" }}
{{- if .Values.environmentName }}
{{- $environmentName = .Values.environmentName | include "toSlug" }}
{{- else if and .Values.global .Values.global.applicationName }}
{{- $environmentName = .Values.global.applicationName | include "toSlug" }}
{{- else }}
{{- $environmentName = .Release.Name | include "toSlug" }}
{{- end }}
{{- print $environmentName -}}
{{- end }}

{{- define "toSlug" -}}
{{- $value := . | lower -}}
{{- $value = regexReplaceAll "\\W+" $value "-" }}
{{- print $value -}}
{{- end -}}