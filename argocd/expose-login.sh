kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0  2>&1 1>/dev/null &

PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)

echo "ArgoCD admin password is $PASSWORD"

argocd login --insecure --username admin --password $PASSWORD localhost:8080 

