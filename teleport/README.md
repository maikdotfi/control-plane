# Teleport for lab usage/demo

```
.
├── modules
│   ├── compute
│   └── teleport
├── nodes #ephemeral nodes, access through teleport
└── server #teleport server, single node
```

## Usage

```bash
cd server
terraform init
terraform apply
./init_teleport.sh
```

```bash
cd ../nodes
export TF_VAR_teleport_auth_server=<auth-server>
export TF_VAR_teleport_join_token=<join-token>
terraform init
terraform apply
open https://${TF_VAR_teleport_auth_server}
```
