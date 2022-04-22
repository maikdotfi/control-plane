# Installation
Install cli (which is just a kubectl plugin):
```bash
curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh
sudo mv kubectl-crossplane /opt/homebrew/bin
# testing the kubectl plugin
kubectl crossplane --help
```

Now install the helm chart into new namespace:
```bash
./install.sh
```

Now we need AWS credentials to create an RDS instance for testing crossplane.

Write a file like this (the usual AWS format):
```bash
[default]
aws_access_key_id = <redacted>
aws_secret_access_key = <redacted>
```

Apply to the cluster:
```bash
kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=./creds.conf
```

Let's build a Crossplane configuration which is a weird single layer OCI container file:
```bash
cd crossplane-config
kubectl crossplane build configuration
ls -lah *.xpkg
docker run -d --restart=always -p "127.0.0.1:5000:5000" --name "local-registry" registry:2
kubectl crossplane push configuration 127.0.0.1:5000/getting-started-with-aws:v1.7.0
kubectl crossplane install configuration 127.0.0.1:5000/getting-started-with-aws:v1.7.0
```

Now we can see the package in the cluster:
```bash
kubectl get pkg
```
Note this gets all the resources under pkg.crossplane.io

Let's actually install the configuration now from external repo, it's tricky to get the local one working in Kind (at least when not on linux):
```bash
kubectl crossplane install configuration registry.upbound.io/xp/getting-started-with-aws:v1.7.0
```

> side note: what is this approach... docs could really explain a bit what's going on and WHY


