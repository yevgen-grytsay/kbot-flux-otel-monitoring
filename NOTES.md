
## OpenTelemetry Collector
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

## Loki
```sh
flux create source helm grafana \
    --namespace=kbot \
    --url=https://grafana.github.io/helm-charts \
    --interval=10m \
    --export > ./cluster/kbot/grafana-helmrepository.yaml

flux create hr loki \
    --namespace=kbot \
    --source=HelmRepository/grafana \
    --chart=loki \
    --chart-version="6.5.2" \
    --interval=10m \
    --values=./otel/loki/helm-values.yaml \
    --export > ./cluster/kbot/loki-helmrelease.yaml
```

## Fluent-bit
```sh
helm repo add fluent https://fluent.github.io/helm-charts
helm repo update fluent
helm show chart fluent/fluent-bit

helm search repo fluent

flux create source helm fluent \
    --namespace=kbot \
    --url=https://fluent.github.io/helm-charts \
    --interval=10m \
    --export > ./cluster/kbot/fluent-bit-helmrepository.yaml

flux create hr fluent-bit \
    --namespace=kbot \
    --source=HelmRepository/fluent \
    --chart=fluent-bit \
    --chart-version="0.46.6" \
    --interval=10m \
    --values=./otel/fluent-bit/helm-values.yaml \
    --export > ./cluster/kbot/fluent-bit-helmrelease.yaml
```

## Grafana
```sh
flux create hr grafana \
    --namespace=kbot \
    --source=HelmRepository/grafana \
    --chart=grafana \
    --chart-version="7.3.11" \
    --interval=10m \
    --values=./otel/grafana/helm-values.yaml \
    --export > ./cluster/kbot/grafana-helmrelease.yaml
```

## Sealed Secrets
```sh
flux create source helm sealed-secrets \
--interval=1h \
--url=https://bitnami-labs.github.io/sealed-secrets \
--export > ./cluster/flux-system/sealed-secrets-helmrepository.yaml


flux create helmrelease sealed-secrets \
--interval=1h \
--release-name=sealed-secrets-controller \
--target-namespace=flux-system \
--source=HelmRepository/sealed-secrets \
--chart=sealed-secrets \
--chart-version=">=1.16.0-0" \
--crds=CreateReplace \
--export > ./cluster/flux-system/sealed-secrets-helmrelease.yaml
```
