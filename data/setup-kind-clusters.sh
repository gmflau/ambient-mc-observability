#!/bin/sh

# Create a workload cluster in us-east-1 region
CURRENT_CONTEXT="kind-workload-cluster-east"
echo; echo "************ Creating ${CURRENT_CONTEXT} ************"
kind create cluster --name "workload-cluster-east" --config data/kind-example-config-east.yaml
# wait for cluster to be ready before installing GME agents
kubectl --context $CURRENT_CONTEXT -n kube-system rollout status deploy/coredns
kubectl --context $CURRENT_CONTEXT -n local-path-storage rollout status deploy/local-path-provisioner
kubectl --context $CURRENT_CONTEXT -n kube-system rollout status ds/kindnet
kubectl --context $CURRENT_CONTEXT -n kube-system rollout status ds/kube-proxy

# Create a workload cluster in us-west-1 region
CURRENT_CONTEXT="kind-workload-cluster-west"
echo; echo "************ Creating ${CURRENT_CONTEXT} ************"
kind create cluster --name "workload-cluster-west" --config data/kind-example-config-west.yaml
# wait for cluster to be ready before installing GME agents
kubectl --context $CURRENT_CONTEXT -n kube-system rollout status deploy/coredns
kubectl --context $CURRENT_CONTEXT -n local-path-storage rollout status deploy/local-path-provisioner
kubectl --context $CURRENT_CONTEXT -n kube-system rollout status ds/kindnet
kubectl --context $CURRENT_CONTEXT -n kube-system rollout status ds/kube-proxy

# Create a management cluster in us-east-1 region
MGMT_CONTEXT=kind-gloo-mgmt-cluster
echo "************ Creating #{MGMT_CONTEXT} ************"
kind create cluster --name "gloo-mgmt-cluster" --config data/kind-example-config-east.yaml
# wait for cluster to be ready
kubectl --context $MGMT_CONTEXT -n kube-system rollout status deploy/coredns
kubectl --context $MGMT_CONTEXT -n local-path-storage rollout status deploy/local-path-provisioner
kubectl --context $MGMT_CONTEXT -n kube-system rollout status ds/kindnet
kubectl --context $MGMT_CONTEXT -n kube-system rollout status ds/kube-proxy