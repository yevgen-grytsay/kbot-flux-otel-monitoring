
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

## Prometheus
```sh
flux create source helm prometheus \
    --namespace=kbot \
    --url=https://prometheus-community.github.io/helm-charts \
    --interval=10m \
    --export > ./cluster/kbot/prometheus-helmrepository.yaml

flux create hr prometheus \
    --namespace=kbot \
    --source=HelmRepository/prometheus \
    --chart=prometheus \
    --chart-version="25.21.0" \
    --interval=10m \
    --values=./otel/prometheus/helm-values.yaml \
    --export > ./cluster/kbot/prometheus-helmrelease.yaml
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

```sh
$ kubeseal --fetch-cert --controller-name=sealed-secrets-controller --controller-namespace=flux-system > pub-sealed-secrets.pem
error: cannot fetch certificate: error trying to reach service: dial tcp 10.1.182.226:8080: i/o timeout
```

### kubeseal `error: cannot fetch certificate` Workaround
https://github.com/bitnami-labs/sealed-secrets/issues/368#issuecomment-1646192551
```sh
kubectl get secret \
  --namespace flux-system \
  --selector sealedsecrets.bitnami.com/sealed-secrets-key=active \
  --output jsonpath='{.items[0].data.tls\.crt}' \
| base64 -d > ./pub-sealed-secrets.pem
```


### Create Secret
```sh
read -s TELE_TOKEN
export TELE_TOKEN

kubectl -n default create secret generic kbot-token-secret \
--namespace=kbot \
--from-literal=token=${TELE_TOKEN} \
--dry-run=client \
-o yaml > ./cluster/kbot/secret.yaml

kubeseal --format=yaml --cert=pub-sealed-secrets.pem \
< ./cluster/kbot/secret.yaml > ./cluster/kbot/secret-sealed.yaml
```

## Kbot

```sh
flux create source git kbot \
    --namespace=kbot \
    --url=https://github.com/yevgen-grytsay/kbot \
    --interval=1m0s \
    --branch=main \
    --export > ./cluster/kbot/kbot-gitrepo.yaml

flux create helmrelease kbot \
    --namespace=kbot \
    --source=GitRepository/kbot \
    --chart=helm \
    --chart-version=">=0.1.7" \
    --interval=1m0s \
    --values=./kbot-helm-values.yaml \
    --export > ./cluster/kbot/kbot-helmrelease.yaml
```

## Dice Server
```sh
flux create source git dice-server \
    --namespace=kbot \
    --url=https://github.com/yevgen-grytsay/otel-dice-server \
    --interval=1m0s \
    --branch=main \
    --export > ./cluster/kbot/dice-server-gitrepo.yaml

flux create helmrelease dice-server \
    --namespace=kbot \
    --source=GitRepository/dice-server \
    --chart=helm \
    --chart-version=">=0.3.1" \
    --interval=1m0s \
    --export > ./cluster/kbot/dice-server-helmrelease.yaml
```

## Misc
```sh
kubectl logs -f --selector="app.kubernetes.io/name=fluent-bit" -n kbot

curl -H "Content-Type: application/json" -XPOST -s "http://127.0.0.1:3100/loki/api/v1/push" --data "{\"streams\": [{\"stream\": {\"job\": \"test\"}, \"values\": [[\"$(date +%s)000000000\", \"fizzbuzz\"]]}]}"

curl "http://127.0.0.1:3100/loki/api/v1/query_range" --data-urlencode 'query={job="test"}' | jq .data.result
```

```sh
ffmpeg -i otel-grafana-2024-05-20_13.51.09.mkv \
    -vf "fps=5" \
    -loop 0 grafana_demo.gif
```
