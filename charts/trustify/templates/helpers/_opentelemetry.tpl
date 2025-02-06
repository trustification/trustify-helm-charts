{{/*
Shares the OTEL_EXPORTER_OTLP_ENDPOINT env var with tracing and metrics signals

Arguments (dict):
  * root - .
  * module - module object
*/}}
{{ define "trustification.application.collector"}}
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: {{ if .root.Values.collector | default "" | trim | eq "" }}"http://infrastructure-otelcol:4317"{{ else }}{{ .root.Values.collector | quote }}{{ end }}
{{- end }}
