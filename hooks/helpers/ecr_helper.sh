#!/usr/bin/env bash

createECR() {
  local repo_name=$1
  echo "============================"
  echo "Add ECR Repo $repo_name"
  aws ecr describe-repositories --repository-names ${repo_name} || aws ecr create-repository --repository-name ${repo_name}
}

deleteECR() {
  local repo_name=$1
  echo "============================"
  echo "Delete ECR Repo $repo_name"
  aws ecr delete-repository --repository-name ${repo_name} --force
}
