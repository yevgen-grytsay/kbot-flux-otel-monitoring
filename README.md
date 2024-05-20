# kbot-flux-otel-monitoring-2

## Loki
```sh
kubectl port-forward -n kbot svc/loki-gateway 3100:80

export LOKI_ADDR=http://127.0.0.1:3100

logcli labels

logcli query '{exporter="OTLP"}'
```

## Grafana
```sh
# Get admin password
kubectl get secret -n kbot grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Port-forwarding
export POD_NAME=$(kubectl get pods -n kbot -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
kubectl -n kbot port-forward $POD_NAME 3000
```

## Prometheus
```sh
export POD_NAME=$(kubectl get pods --namespace kbot -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus" -o jsonpath="{.items[0].metadata.name}")

kubectl --namespace kbot port-forward $POD_NAME 9090
```
