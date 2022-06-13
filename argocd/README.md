# Installation

Install with `install.sh` and then wait for pods to be running, then run `expose-login.sh` to expose the argocd ui on ::8080 and login the CLI.

## imperative (using CLI) hello world

```bash
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app sync guestbook
```

## declarative (yaml + kubectl) hello world

ArgoCD apps (and itself) can be managed fully declaratively, meaning we can `kubectl apply` the whole thing and ArgoCD controllers will reconcile those resources in the cluster. Of course we need to initially have an ArgoCD instance running in order to bootstrap this process. Here's how to define the guestbook in yaml:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook-declarative
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/argoproj/argocd-example-apps.git
    targetRevision: HEAD
    path: guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: guestbook
  syncPolicy:
    automated: {}
```

Notice `syncPolicy.automated` this means we don't need to run `argocd app sync`, instead the application will be created right away when this is applied.

Deploy:

```
kubectl apply -f guestbook.yaml
```
