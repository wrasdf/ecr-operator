#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo
  echo "usage: ./bin/deploy.sh <cluster>"
  echo "  ie. ./bin/deploy.sh alpha-apse2-v1"
  exit 255
fi

cluster=${1}
overlayComponent="_build/${cluster}/ecr-operator"

./bin/compile.sh $cluster

# stackup cfn for component
if [[ -f "${overlayComponent}/cfn/template.yaml" ]]
then
  echo ":cloudformation: deploying cfn for ecr-operator"
  docker-compose run --rm stackup "ecr-operator-${cluster}" up -t ${overlayComponent}/cfn/template.yaml
fi

docker-compose run --rm kubectl apply -f ${overlayComponent}
