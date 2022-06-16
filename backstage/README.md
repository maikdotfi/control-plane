# Backstage installation

This folder contains the manifests for deploying postgres for state storage and then backstage itself.

**Gave up on making this work, for some reason it likes to forward the browser from http to https. It's only a default app as well so nothing really to see, but if even that won't work according to docs..**

Overall I can't believe how god damn bloated the project is, I can't imagine developing more on top of such a pile of crap.

## Build Backstage image

Backstage is not very user friendly to deploy, one must create an app and then build it locally:

```bash
git clone --depth=1 https://github.com/backstage/backstage.git
cd backstage/
npx @backstage/create-app
cd example-app/
yarn build
yarn build-image --tag localhost:5000/backstage:1.0.0
docker push localhost:5000/backstage:1.0.0
```

> NOTE: this will take a long time...

If you need to customize the installation that can be done by editing `app-config.production.yaml`.


## Using Argo to Deploy (WIP)

ArgoCD luckily has an intelligent way of syncing the resources, so it should work without any additional metadata, if not it's possible to affect the order of resource creation during a sync: <https://argo-cd.readthedocs.io/en/stable/user-guide/sync-waves/> see also this if having issues (only apps-of-apps pattern?): <https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/1.7-1.8/#health-assessement-of-argoprojioapplication-crd-has-been-removed> 

Exposing backstage UI:

```
kubectl port-forward --address 0.0.0.0 -n backstage svc/backstage 7007:80 &
```
