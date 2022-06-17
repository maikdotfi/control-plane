# Kicking tires

Firstly Boundary must be installed, I used `dnf` on Fedora but one could even just fetch the binary directly.

## Short notes on the Architecture

Boundary consists of two main components: controller(s) and worker(s). Controllers expose an API on port 9200 and 'cluster' API on 9201. In order to make connections to hosts in private networks the workers act as bastion hosts which you must connect through port 9202 (you must connect directly to worker, not just controller!). The workers themselves talk to the controllers on port 9201, so there's fair bit of connectivity required for Boundary to function correctly.

Boundary requires a KMS to be available, interestingly this seems true for both server and client side. When you authenticate with a boundary server (controller) the boundary cli tries to store the token securely, which is interesting but only works smoothly on MacOS apparently with the keychain (they're working on improving this). On the server side there's similar need to store cryptographic material, for that you can use a Cloud provider's KMS service (e.g. AWS KMS), but you can also use HashiCorp Vault's Transit engine as neutral solution. Boundary also requires a Postgres.

## Demo

As a demo we will start up Boundary in dev mode, which will start an in-memory postgres instance as well (I guess that's why it takes a while to actually run the command):

```
boundary dev -api-listen-address=0.0.0.0
```

> this exposes the UI/API on all interfaces, useful if connecting to a headless server (like I'm always)

This will obviously run all the boundary server components as one, and even adds the localhost (boundary itself) as auto generated target/host in the system. We will connect to that automatically added host next:

Since I want this to work on any machine, let's set the boundary token to not be stored:

```bash
export BOUNDARY_TOKEN_NAME=none
```

Next we need to get the TARGET_ID (identity of the machine?) and the ID of the AUTH method (password in this case):

```bash
export TARGET_ID=ttcp_1234567890
export AUTH_ID=ampw_1234567890
```

First we login and get a token (kinda like Vault token):

```
boundary authenticate password -auth-method-id=$AUTH_ID     -login-name=admin -password=password
```

This token can be used directly (or through a TPM on localhost) to connect to the target (admin can do that ofc):

```bash
boundary connect ssh -target-id $TARGET_ID -token at_qhMI6FSFy0_s1CbkQJsdNuJuVhrruC72iLWiDuFNJHE4YitCbTD4eHKnRMJaYjCBuYm2zMzqznN7XHZNjrFpoZMQmtWi3z8cdKkUXwsrMaYyKaEjenPbiuGRgjjmYbudrC1naBCvJjdiK2T9v8cMyRH3cCFd
```

Since the auth method is password, there will be a login prompt. Interestingly Boundary doesn't yet support SSH CA's so it's kinda awkward to make this much better which is definitely a big issue and thus I've chosen to explore teleport instead.
