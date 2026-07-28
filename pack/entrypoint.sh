#!/bin/bash
# shellcheck disable=SC1091,SC1090

set -e

source /etc/s6-overlay/scripts/base.sh
ARGS_FILE="/run/gpustack/args"
mkdir -p "$(dirname "$ARGS_FILE")"

# If any arguments are passed to the container, save them to the args file
if [ "$#" -gt 0 ]; then
    echo "[INFO] Saving docker run args to $ARGS_FILE"
    : > "$ARGS_FILE"
    for arg in "$@"; do
        printf '%s\n' "$arg" >> "$ARGS_FILE"
    done
else
    echo "[INFO] No docker run args passed."
    : > "$ARGS_FILE"
fi

# remove generated gateway config to force regeneration
rm -rf "${GPUSTACK_GATEWAY_CONFIG}"

export S6_STAGE2_HOOK="/etc/s6-overlay/scripts/gpustack-prerun.sh"

[ -n "$SGISTACK_RUNTIME_DEPLOY_MIRRORED_NAME" ] && export GPUSTACK_RUNTIME_DEPLOY_MIRRORED_NAME="$SGISTACK_RUNTIME_DEPLOY_MIRRORED_NAME"
[ -n "$SGISTACK_DATABASE_URL" ] && export GPUSTACK_DATABASE_URL="$SGISTACK_DATABASE_URL"
[ -n "$SGISTACK_PORT" ] && export GPUSTACK_PORT="$SGISTACK_PORT"
[ -n "$SGISTACK_MODEL_CATALOG_FILE" ] && export GPUSTACK_MODEL_CATALOG_FILE="$SGISTACK_MODEL_CATALOG_FILE"
[ -n "$SGISTACK_BOOTSTRAP_PASSWORD" ] && export GPUSTACK_BOOTSTRAP_PASSWORD="$SGISTACK_BOOTSTRAP_PASSWORD"
[ -n "$SGISTACK_TOKEN" ] && export GPUSTACK_TOKEN="$SGISTACK_TOKEN"

[ -n "$SGISTACK_SERVER_URL" ] && export GPUSTACK_SERVER_URL="$SGISTACK_SERVER_URL"
[ -n "$SGISTACK_WORKER_NAME" ] && export GPUSTACK_WORKER_NAME="$SGISTACK_WORKER_NAME"
[ -n "$SGISTACK_WORKER_IP" ] && export GPUSTACK_WORKER_IP="$SGISTACK_WORKER_IP"
[ -n "$SGISTACK_RUNTIME_DEPLOY" ] && export GPUSTACK_RUNTIME_DEPLOY="$SGISTACK_RUNTIME_DEPLOY"
[ -n "$SGISTACK_RUNTIME_DEPLOY_MIRRORED_DEPLOYMENT" ] && export GPUSTACK_RUNTIME_DEPLOY_MIRRORED_DEPLOYMENT="$SGISTACK_RUNTIME_DEPLOY_MIRRORED_DEPLOYMENT"
[ -n "$SGISTACK_RUNTIME_KUBERNETES_NAMESPACE" ] && export GPUSTACK_RUNTIME_KUBERNETES_NAMESPACE="$SGISTACK_RUNTIME_KUBERNETES_NAMESPACE"
[ -n "$SGISTACK_RUNTIME_KUBERNETES_NODE_NAME" ] && export GPUSTACK_RUNTIME_KUBERNETES_NODE_NAME="$SGISTACK_RUNTIME_KUBERNETES_NODE_NAME"

# shellcheck disable=SC2068
exec /init gpustack start $@
