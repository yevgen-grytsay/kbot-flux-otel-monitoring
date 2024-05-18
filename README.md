# kbot-flux-otel-monitoring-2

## Loki
```sh
kubectl port-forward -n kbot svc/loki-gateway 3100:80

export LOKI_ADDR=http://127.0.0.1:3100

logcli labels

logcli query '{exporter="OTLP"}'
```
