#!/bin/sh
kubectl create ns redis
kubectl apply -f redis-secret.yaml
helmsman -apply -f helmsman.config.yaml