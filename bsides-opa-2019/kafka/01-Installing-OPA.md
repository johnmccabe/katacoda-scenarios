## Install OPA

1. Create the `opa` namespace:

    `docker-compose --project-name opa-kafka-tutorial up`{{execute}}

2. asdasd

    `docker run --rm --network opakafkatutorial_default \
    openpolicyagent/demo-kafka:1.0 \
    bash -c 'for i in {1..10}; do echo "{\"user\": \"bob\", \"score\": $i}"; done | kafka-console-producer --topic credit-scores --broker-list kafka:9093 -producer.config /etc/kafka/secrets/anon_producer.ssl.config'`{{execute}}