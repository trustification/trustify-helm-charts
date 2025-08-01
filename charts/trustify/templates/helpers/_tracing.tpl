{{/*
Is tracing enabled?

Arguments (dict):
  * .
*/}}
{{ define "trustification.application.tracing.enabled"}}
{{- .Values.tracing.enabled }}
{{- end }}

{{/*
Maximum number of spans to export in a batch.

Arguments (dict):
  * .
*/}}
{{ define "trustification.application.tracing.otelBspMaxExportBatchSize"}}
{{- if hasKey .root.Values.tracing "otelBspMaxExportBatchSize" }}
- name: OTEL_BSP_MAX_EXPORT_BATCH_SIZE
  value: {{ .root.Values.tracing.otelBspMaxExportBatchSize | quote }}
{{ end }}
{{- end }}

{{/*
Sampler strategy used for OpenTelemetry traces.

Arguments (dict):
  * .
*/}}
{{ define "trustification.application.tracing.otelTracesSampler"}}
{{- if hasKey .root.Values.tracing "otelTracesSampler" }}
- name: OTEL_TRACES_SAMPLER
  value: {{ .root.Values.tracing.otelTracesSampler | quote }}
{{ end }}
{{- end }}

{{/*
Sampling probability, a floating-point number between 0 and 1
(e.g., "0.1" for a 10% sampling rate)

Arguments (dict):
  * .
*/}}
{{ define "trustification.application.tracing.otelTracesSamplerArg"}}
{{- if hasKey .root.Values.tracing "otelTracesSamplerArg" }}
- name: OTEL_TRACES_SAMPLER_ARG
  value: {{ .root.Values.tracing.otelTracesSamplerArg | quote }}
{{ end }}
{{- end }}
