#!/usr/bin/env bash

source /hooks/helpers/ecr_helper.sh

if [[ $1 == "--config" ]] ; then
  cat <<EOF
configVersion: v1
kubernetes:
  - apiVersion: afterpay.com/v1beta1
    kind: ECR
    executeHookOnEvent:
      - Added
      - Deleted
EOF
else

  type=$(jq -r '.[0].type' ${BINDING_CONTEXT_PATH})
  event=$(jq -r '.[0].watchEvent' ${BINDING_CONTEXT_PATH})

  if [[ $type == "Event" ]] ; then

    namespace=$(jq -r '.[0].object.metadata.namespace' ${BINDING_CONTEXT_PATH})
    name=$(jq -r '.[0].object.metadata.name' ${BINDING_CONTEXT_PATH})

    if [[ $event == "Added" ]]; then
      createECR "k8s/${namespace}/${name}"
    fi

    if [[ $event == "Deleted" ]]; then
      deleteECR "k8s/${namespace}/${name}"
    fi

  fi
fi
