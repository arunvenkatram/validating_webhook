#!/bin/bash
kubectl create ns webhook
bash gen_certs.sh
docker build -t valwh:1.0.0 .
kubectl create secret generic arun-secret -n webhook \
        --from-file=key.pem=certs/val-key.pem \
        --from-file=cert.pem=certs/val_key-crt.pem
kubectl apply -f manifest.yaml
