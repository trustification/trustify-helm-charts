{{/*
Evaluate the infrastructure port.

Arguments: (dict)
  * root - .
  * module - module object
*/}}
{{- define "trustification.application.infrastructure.port"}}
{{- $infra := merge (deepCopy .module.infrastructure ) .root.Values.infrastructure }}
{{- $infra.port | default 9010 -}}
{{- end }}

{{/*
Evaluate the infrastructure initial delay seconds.

Arguments: (dict)
  * root - .
  * module - module object
*/}}
{{- define "trustification.application.infrastructure.initialDelaySeconds"}}
{{- $infra := merge (deepCopy .module.infrastructure ) .root.Values.infrastructure }}
{{- $infra.initialDelaySeconds | default 2 -}}
{{- end }}

{{/*
Additional env-vars for configuring the infrastructure endpoint.

Arguments (dict):
  * root - .
  * module - module object
*/}}
{{- define "trustification.application.infrastructure.envVars"}}
- name: INFRASTRUCTURE_ENABLED
  value: "true"
- name: INFRASTRUCTURE_BIND
  value: "[::]:{{- include "trustification.application.infrastructure.port" . }}"

{{- if eq ( include "trustification.application.metrics.enabled" .root ) "true" }}
- name: METRICS
  value: "enabled"
{{ include "trustification.application.metrics.otelMetricExportInterval" . }}
{{- end }}

{{- if eq ( include "trustification.application.tracing.enabled" .root ) "true" }}
- name: TRACING
  value: "enabled"
{{ include "trustification.application.tracing.otelBspMaxExportBatchSize" . }}
{{ include "trustification.application.tracing.otelTracesSampler" . }}
{{ include "trustification.application.tracing.otelTracesSamplerArg" . }}
{{- end }}

{{- if eq ( include "trustification.application.collector.enabled" .root ) "true" }}
{{ include "trustification.application.collector" . }}
{{- end }}

{{- end }}

{{/*
Pod port definition for the infrastructure endpoint.

Arguments (dict):
  * root - .
  * module - module object
*/}}
{{- define "trustification.application.infrastructure.podPorts" }}
- containerPort: {{ include "trustification.application.infrastructure.port" . }}
  protocol: TCP
  name: infra
{{- end}}

{{/*
Standard infrastructure probe definitions.

Arguments (dict):
  * root - .
  * module - module object
*/}}
{{ define "trustification.application.infrastructure.probes" }}
livenessProbe:
  initialDelaySeconds: {{ include "trustification.application.infrastructure.initialDelaySeconds" . }}
  httpGet:
    path: /health/live
    port: {{ include "trustification.application.infrastructure.port" . }}

readinessProbe:
  initialDelaySeconds: {{ include "trustification.application.infrastructure.initialDelaySeconds" . }}
  httpGet:
    path: /health/ready
    port: {{ include "trustification.application.infrastructure.port" . }}

{{- end }}
