#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo
  echo "usage: ./bin/compile.sh <cluster> <version>"
  echo "  ie. ./bin/compile.sh alpha-apse2-v1 v0.1.30"
  exit 255
fi


cluster=${1}
version=${2}
configfile=clusters/${cluster}.yaml

function prepareBuildFolder() {
  echo "preparing $cluster template"
  rm -rf _build
  mkdir -p _build/${cluster}
}

function castTemplate() {

  echo -n "casting $cluster templates"

  docker-compose run -e version=${version} --rm gomplate \
    --left-delim='<<' --right-delim='>>' \
    --input-dir ./templates/ \
    --output-dir=_build/${cluster}/ \
    --context config=${configfile}
}

if [[ ! -f "${configfile}" ]]
then
  echo "error: configfile does not exist: ${configfile}"
  exit 1
fi

prepareBuildFolder
castTemplate

echo "node!"
