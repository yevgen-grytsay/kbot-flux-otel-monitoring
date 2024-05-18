

```sh
flux create source helm open-telemetry \
    --namespace=kbot \
    --url=https://open-telemetry.github.io/opentelemetry-helm-charts \
    --interval=10m \
    --export > ./cluster/kbot/collector-helmrepository.yaml

# flux create source chart collector \
#     --namespace=kbot \
#     --source=HelmRepository/open-telemetry \
#     --chart=opentelemetry-collector \
#     --chart-version=0.91.0 \
#     --export

flux create hr collector \
    --namespace=kbot \
    --source=HelmRepository/open-telemetry \
    --chart=opentelemetry-collector \
    --chart-version="0.91.0" \
    --interval=10m \
    --values=./otel/collector/helm-values.yaml \
    --export > ./cluster/kbot/collector-helmrelease.yaml
```
