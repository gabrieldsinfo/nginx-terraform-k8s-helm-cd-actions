{{- define "nginx-chart.name" -}}
nginx-chart
{{- end }}

{{- define "nginx-chart.fullname" -}}
{{ .Release.Name }}-{{ include "nginx-chart.name" . }}
{{- end }}
