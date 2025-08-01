{{/*
Are metrics enabled?

Arguments (dict):
  * .
*/}}
{{ define "trustification.application.metrics.enabled"}}
{{- .Values.metrics.enabled }}
{{- end }}

{{/*
Pod labels for metrics.

Arguments (dict):
  * root - .
  * module - module object
*/}}
{{ define "trustification.application.metrics.podLabels" }}
{{- if eq (include "trustification.application.metrics.enabled" .root ) "true" }}
metrics: "true"
{{ end }}
{{- end }}

{{/*
Specifies how frequently metrics are exported by the application.

Arguments (dict):
  * .
*/}}
{{ define "trustification.application.metrics.otelMetricExportInterval"}}
{{- if hasKey .root.Values.metrics "otelMetricExportInterval" }}
- name: OTEL_METRIC_EXPORT_INTERVAL
  value: {{ .root.Values.metrics.otelMetricExportInterval | quote }}
{{ end }}
{{- end }}
