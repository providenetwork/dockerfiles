#!/bin/bash

get_build_info()
{
  echo '....Getting build values....'
  revNumber=$(echo `git rev-list HEAD | wc -l`)
  gitHash=`git rev-parse --short HEAD`
  gitBranch=`git rev-parse --abbrev-ref HEAD`
  buildDate=$(date '+%m.%d.%y')
  buildTime=$(date '+%H.%M.%S')
  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; if [ "$?" -ne "0" ]; then echo 'Local git status is dirty'; fi )";
  buildRef=${gitBranch}-${gitHash}-${buildDate}-${buildTime}
  echo 'Build Ref =' $buildRef
}

build_and_push()
{
  buildPath=$1
  orgname=$2

  project=$(echo "${buildPath}" | sed 's/\//-/g')
  repo="${orgname}/${project}"

  echo "Building dockerfile ${buildPath}... resolved repo: ${repo}"
  pushd "${buildPath}"
  docker build -t "${repo}" .
  docker tag ${repo}:latest ${repo}:${buildRef}
  docker push ${repo}:${buildRef}
  docker push ${repo}:latest
  popd
}

main()
{
  if [[ -z "${DOCKERHUB_ORG_NAME}" ]]; then
    DOCKERHUB_ORG_NAME="provide"
  fi

  pkgs=(.)
  for pkg in "${pkgs[@]}" ; do
    files=$(find . -name Dockerfile)
    for file in $files[@]; do
      path=$(echo "${file}" | sed 's/\/Dockerfile$//g' | sed 's/^.\///g')
      build_and_push "${path}" $DOCKERHUB_ORG_NAME
    done
  done
}

main
