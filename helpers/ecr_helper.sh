#!/usr/bin/env bash

function createECR {
  local repo_name=$1
  echo "Add ECR Repo: $repo_name"
  aws ecr describe-repositories --repository-names ${repo_name} || aws ecr create-repository --repository-name ${repo_name}
}

function deleteECR {
  local repo_name=$1
  echo "Delete ECR Repo: $repo_name "
  aws ecr describe-repositories --repository-names ${repo_name} && aws ecr delete-repository --repository-name ${repo_name} --force
}

function patchCRDStatus {
  local repo_name=$1
  local crd_namespace=$(echo $repo_name |cut -f 2 -d "/")
  local crd_name=$(echo $repo_name |cut -f 3 -d "/")
  local results=$(aws ecr describe-repositories --repository-names ${repo_name} | jq --raw-output .repositories[0])
  cat > /tmp/patch-${crd_name}.json << EOF
{
  "status": {
    "ecr": ${results}
  }
}
EOF
  echo $crd_namespace
  echo $crd_name
  cat /tmp/patch-${crd_name}.json | cfn-flip > /tmp/patch-${crd_name}.yaml
  cat /tmp/patch-${crd_name}.yaml
  # kubectl -n ${crd_namespace} patch ecrs ${crd_name} --patch "$(cat /tmp/patch-${crd_name}.yaml)"
}

# patchCRDStatus k8s/pe/delete-me-ecr
