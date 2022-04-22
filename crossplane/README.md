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

This above package is actually failing to install, let's see why by inspecting the ConfigurationRevision:
```bash
$ kubectl describe configurationrevision
...
Events:
  Type     Reason               Age                 From                                              Message
  ----     ------               ----                ----                                              -------
  Warning  ResolveDependencies  47s (x32 over 26m)  packages/configurationrevision.pkg.crossplane.io  cannot resolve package dependencies: Invalid Semantic Version
```

This remains bit of a mystery to me what's wrong with semantic versioning, this package is the official getting started tutorial...

Anyhow we don't have to care about that, the XRD (CompositeResourceDefinition) and composition can be applied directly to a cluster!
```bash
cd crossplane-config
kubectl apply -f definition.yaml
kubectl apply -f composition.yaml
```

Now we can create an RDS instance:
```bash
cd ../manifests
kubectl apply -f claim-aws.yaml
kubectl describe postgresqlinstance
```
It will take a long time for AWS to provision this, but eventually it will become available and writes a secret:
```bash
kubectl get secret db-conn -o yaml
```

## But I don't care about RDS!
We can find out about other resource APIs with kubectl, for example if I want to create an EC2 instance I can get the fields and descriptions like this:
```bash
kubectl explain instances.spec.forProvider
```

## Inspecting Crossplane configuration packages
Let's build a Crossplane configuration which is a weird single layer OCI container file:
```bash
cd crossplane-config
kubectl crossplane build configuration
ls -lah *.xpkg
```

Now this file can be pushed to any OCI compliant container registry, we can try that locally:
```bash
docker run -d --restart=always -p "127.0.0.1:5000:5000" --name "local-registry" registry:2
kubectl crossplane push configuration 127.0.0.1:5000/getting-started-with-aws:v1.7.0
kubectl crossplane install configuration 127.0.0.1:5000/getting-started-with-aws:v1.7.0
```

We can also inspect the xpkg file locally with tar:
```bash
mv getting-started-with-aws-6acb3f709c6c.xpkg getting-started-with-aws-6acb3f709c6c.tar.gz
tar -xvf getting-started-with-aws-6acb3f709c6c.tar.gz
tar -xzvf ac8581df5402fda8e3100b72cbe1e58420e5cd9bdda88ee6c44b769569f2f62f.tar.gz
vim package.yaml
```
