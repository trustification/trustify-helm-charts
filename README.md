# Deploying Trustify using Helm

## From a local checkout

From a local copy of the repository, execute one of the following deployments.

### Minikube

Create a new cluster:

```bash
minikube start --cpus 8 --memory 24576 --disk-size 20gb --addons ingress,dashboard
```

Create a new namespace:

```bash
kubectl create ns trustify
```

Use it as default:

```bash
kubectl config set-context --current --namespace=trustify
```

Install the infrastructure services:

```bash
APP_DOMAIN=.$(minikube ip).nip.io
helm upgrade --install --dependency-update -n trustify infrastructure charts/trustify-infrastructure --values values-minikube.yaml --set-string keycloak.ingress.hostname=sso$APP_DOMAIN --set-string appDomain=$APP_DOMAIN
```

Then deploy the application:

```bash
APP_DOMAIN=.$(minikube ip).nip.io
helm upgrade --install -n trustify trustify charts/trustify --values values-minikube.yaml --set-string appDomain=$APP_DOMAIN
```

### Kind

Create a new cluster:

```bash
kind create cluster --config kind/config.yaml
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml
```

Create a new namespace:

```bash
kubectl create ns trustify
```

Use it as default:

```bash
kubectl config set-context --current --namespace=trustify
```

Install the infrastructure services:

```bash
APP_DOMAIN=.$(kubectl get node kind-control-plane -o jsonpath='{.status.addresses[?(@.type == "InternalIP")].address}' | awk '// { print $1 }').nip.io
helm upgrade --install --dependency-update -n trustify infrastructure charts/trustify-infrastructure --values values-minikube.yaml --set-string keycloak.ingress.hostname=sso$APP_DOMAIN --set-string appDomain=$APP_DOMAIN
helm upgrade --install -n trustify trustify charts/trustify --values values-minikube.yaml --set-string appDomain=$APP_DOMAIN
```

## From a released chart

Instead of using a local checkout, you can also use a released chart.

> [!NOTE]
> You will still need a "values" files, providing the necessary information. If you don't clone the repository, you'll
> need to create a value yourself.

For this, you will need to add the following repository:

```bash
helm repo add trustify https://trustification.io/trustify-helm-charts/
```

And then, modify any of the previous `helm` commands to use:

```bash
helm […] --devel trustify/<chart> […]
```
