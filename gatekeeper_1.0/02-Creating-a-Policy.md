## Creating a Policy

1. Store the provided policy as a configmap, view its contents with `cat image-whitelist.rego`{{execute}}. This policy will reject any `Pod`, `Deployment` or `Job` with an image that does not come from the `docker.io` registry (for either `CREATE` or `UPDATE`).

    `kubectl create configmap image-whitelist --from-file=image-whitelist.rego -n opa`{{execute}}

2. Test the success case where we create a deployment from a whitelisted registry. `cat deployment-docker-ok.yaml`{{execute}}.

    `kubectl apply -f ./deployment-docker-ok.yaml`{{execute}}

    This should deploy successfully.

3. Check that the policy has been validated, compiled and loaded into OPA.

    `kubectl get configmap -n opa image-whitelist -o yaml`{{execute}}

    You should see a status annotation indicating `OK`.

    ```
    metadata:
      annotations:
        openpolicyagent.org/policy-status: '{"status":"ok"}'
    ```
4. Now we test the negative case where we create a deploying from a non-whitelisted registry, `gcr.io` in this case. `cat deployment-gcr-bad.yaml`{{execute}}

    `kubectl apply -f ./deployment-gcr-bad.yaml`{{execute}}

    This should be rejected with a message explaining why.