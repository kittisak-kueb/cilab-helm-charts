{{- define "operPort" -}}
8080
{{- end -}}
{{- define "cilab.operEnv" -}}
- name: ACCESS_ORIGIN
  value: {{ .Values.operConfigmap.ACCESS_ORIGIN | quote }}
- name: APP_NAME
  value: {{ .Values.name | quote }}
- name: API_PORT
  value: "{{ template "operPort" . | quote }}"
- name: NAMESPACE
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: metadata.namespace
- name: INITIAL_ADMIN_USER
  value: {{ .Values.operConfigmap.INITIAL_ADMIN_USER | quote }}
{{- if (default .Values.oidc.enable false)}}
- name: OIDC_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: oidc
      key: OIDC_CLIENT_SECRET
{{- end}}
- name: TZ
  value: {{ .Values.timezone | quote }}
{{- end -}}
{{- define "cilab.operCfg" -}}
GIT_IMAGE: {{ .Values.images.git }}
DEFAULT_IMAGE: {{ .Values.images.default }}
JOB_BACKOFF_LIMIT: {{ .Values.operConfigmap.JOB_BACKOFF_LIMIT | quote }}
CI_OPERATOR_IMAGE: {{ .Values.images.ci }}
CI_OPERATOR_NAME: {{ .Values.operConfigmap.CI_OPERATOR_NAME | quote }}
LOG_CONTAINER_NAME: {{ .Values.operConfigmap.LOG_CONTAINER_NAME | quote }}
LOG_TIME_SINCE: {{ .Values.operConfigmap.LOG_TIME_SINCE | quote }}
GIT_SRC_PATH: {{ .Values.operConfigmap.GIT_SRC_PATH | quote }}
{{- end -}}
{{- define "wsPort" -}}
3001
{{- end -}}
{{- define "cilab.wsEnv" -}}
- name: PORT
  value: "{{ template "wsPort" . | quote }}"
- name: TZ
  value: {{ .Values.timezone | quote }}
{{- end -}}