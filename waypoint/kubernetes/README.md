# Walkthrough of tutorial w/ some thoughts

Firstly spun up `kind` cluster from the `kind` folder of this repo.


## Install Waypoint server to k8s

The installation on Kind will require a LB (k3d would have this but have some strange issues with it on Fedora). Let's install metallb on kind to get a loadbalancer which is quite useless:

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.12.1/manifests/metallb.yaml
kubectl get pods -n metallb-system --watch
```

```bash
# when pods running continue, don't worry about configError status
docker network inspect -f '{{.IPAM.Config}}' kind
```

vim lb.yaml
```bash
# check the CIDR and update below manifest to match
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 172.18.255.200-172.18.255.250 #port range for lbs
```

```bash
k apply -f lb.yaml
```

Now loadbalancer services should work! Notice you need to manually delete waypoint resources from cluster if you tried to install without the loadbalancer svc becoming available.

Install waypoint (finally):

```
waypoint install --platform=kubernetes -accept-tos
```

## Example app
