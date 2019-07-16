## Install OPA

1. Create the `opa` namespace:

    `kubectl create namespace opa`{{execute}}

2. Communication between Kubernetes and OPA must be secure with TLS. Use `openssl` to create a CA and certificate key/pair for OPA.

    `openssl genrsa -out ca.key 2048`{{execute}}

    `openssl req -x509 -new -nodes -key ca.key -days 100000 -out ca.crt -subj "/CN=admission_ca"`{{execute}}

3. Using the provided `server.conf` generate the TLS key/cert for OPA.

    `openssl genrsa -out server.key 2048`{{execute}}

    `openssl req -new -key server.key -out server.csr -subj "/CN=opa.opa.svc" -config server.conf`{{execute}}

    `openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 100000 -extensions v3_req -extfile server.conf`{{execute}}

4. Create a Secret to store the TLS creds for OPA.

    `kubectl create secret tls opa-server --cert=server.crt --key=server.key`{{execute}}

5. Use the provided YAML to deploy OPA as an admission controller, using an [ValidatingAdmissionWebhook](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#validatingadmissionwebhook) here for flexibility. This could also be implemented as an [ImagePolicyWebhook](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#imagepolicywebhook) if desired.

    `kubectl apply -f admission-controller.yaml`{{execute}}

6. Generate the YAML used to register OPA as a ValidatingWebhookConfiguration admission controller.

    `sed -i .bak "s/caBundle: .*/caBundle: $(cat ca.crt | base64 | tr -d '\n')/" ./webhook-configuration.yaml`{{execute}}

7. Label the `kube-system` and `opa` namespaces to that OPA does not apply policy to them.

    `kubectl label ns kube-system openpolicyagent.org/webhook=ignore`{{execute}}

    `kubectl label ns opa openpolicyagent.org/webhook=ignore`{{execute}}