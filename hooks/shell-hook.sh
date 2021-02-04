#!/usr/bin/env bash

source /helpers/ecr_helper.sh

if [[ $1 == "--config" ]] ; then
  cat <<EOF

configVersion: v1
kubernetes:
  - name: OnCreateDeleteECR
    apiVersion: afterpay.com/v1beta1
    kind: ECR
    executeHookOnEvent:
      - Added
      - Deleted

  - name: OnModifiedECR
    apiVersion: afterpay.com/v1beta1
    kind: ECR
    executeHookOnEvent:
      - Modified
    jqFilter: .spec

EOF
else

  type=$(jq -r '.[0].type' ${BINDING_CONTEXT_PATH})
  event=$(jq -r '.[0].watchEvent' ${BINDING_CONTEXT_PATH})

  if [[ $type == "Event" ]] ; then

    namespace=$(jq -r '.[0].object.metadata.namespace' ${BINDING_CONTEXT_PATH})
    name=$(jq -r '.[0].object.metadata.name' ${BINDING_CONTEXT_PATH})

    if [[ $event == "Added" ]]; then
      echo "Add----- k8s/${namespace}/${name}"
    fi

    if [[ $event == "Deleted" ]]; then
      echo "Deleted------  k8s/${namespace}/${name}"
    fi

    if [[ $event == "Modified" ]]; then
      echo "Modified------- k8s/${namespace}/${name}"
    fi

  fi

fi
