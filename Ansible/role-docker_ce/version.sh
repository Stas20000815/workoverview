#!/bin/bash
version_tag(){
  set +e
  tag=$(git describe --tags --first-parent --match "version/start/*" 2>/dev/null)
  exit_code=$?
  set -e
  if [ $exit_code -ne "0" ]
  then
    >&2 echo "git tag: 'version/start/* missing"
    exit $exit_code
  fi
  echo "$tag"
}

current_version(){
  set -e
  version=$(version_tag)
  echo "$version" | cut -d'/' -f 3 | cut -d'-' -f 1
}

major_version(){
  set -e
  current=$(current_version)
  echo "$current" | cut -d'.' -f 1
}

minor_version(){
  set -e
  current=$(current_version)
  echo "$current" | cut -d'.' -f 2
}

patch_version(){
  set -e
  current=$(current_version)
  echo "$current" | cut -d'.' -f 3
}

commit_sha(){
  git rev-parse HEAD
}

current_branch(){
  git rev-parse --abbrev-ref HEAD
}

next_major_version(){
  set -e
  major=$(major_version)
  echo $((major +1)).0.0
}

next_minor_version(){
  set -e
  major=$(major_version)
  minor=$(minor_version)
  echo "$major".$((minor + 1 )).0
}

next_patch_version(){
  set -e
  patch=$(patch_version)
  major=$(major_version)
  minor=$(minor_version)
  echo "$major.$minor.$((patch +1))"
}

commits_count(){
  set -e
  version=$(version_tag)
  current=$(current_version)
  commit_number=$(echo "$version" | cut -d'/' -f 3 | cut -d'-' -f 2)
  if [ "$current" = "$commit_number" ]
  then
    echo 0
  else
    echo "$commit_number"
  fi
}

app_version(){
  set -e
  current=$(current_version)
  commits=$(commits_count)
  echo "$current-$commits"
}

init(){
  set -e
  version=$1
  git tag "version/start/$version" &&\
  git push --tags origin "$(current_branch)"
}

create_release_branch(){
    set -e
    minor_version=$1.0
    release_branch=release/$1

    git reset --hard HEAD &&\
    git checkout "version/end/$minor_version" &&\
    git checkout -b "$release_branch" &&\
    git commit --allow-empty -m"Branch for Patching $minor_version" &&\

    new_version="$(next_patch_version)" &&\

    git tag "version/start/$new_version" &&\
    git push origin -u "$release_branch" --tags
}

change_version(){
  set -e
  current_ver=$1
  new_version=$2

  git tag "version/end/$current_ver" &&\
  git commit --allow-empty -m"Incrementing version number to $new_version" &&\
  git tag "version/start/$new_version" &&\
  git push --tags origin "$(current_branch)"
}

increase_patch_version(){
  set -e
  if [[ "$(current_branch)" =  release/* ]]
  then
    git reset --hard HEAD &&\
    git pull --rebase &&\

    current_ver="$(current_version)" &&\
    new_version="$(next_patch_version)" &&\

    change_version "$current_ver" "$new_version"
  else
    echo This is not a release branch >&2
  fi
}

increase_minor_version(){
  set -e
  git reset --hard HEAD &&
  git pull --rebase &&\

  current_ver="$(current_version)" &&\
  new_version="$(next_minor_version)" &&\

  change_version "$current_ver" "$new_version"
}

test(){
  echo "$1 $2 $3 --- $*"
}
increase_major_version(){
  set -e
  git reset --hard HEAD &&
  git pull --rebase &&\

  current_ver="$(current_version)" &&\
  new_version="$(next_major_version)" &&\

  change_version "$current_ver" "$new_version"
}

list_of_functions=$(grep -v "grep" "$0" | grep "()" | cut -d '(' -f 1)
help()
{
  printf "%s\n\n%s\n" "Usage: Provide any of the following sub_commands:" "$list_of_functions"
}

echo "$list_of_functions" | grep -w "$1" -q

exit_code=$?

if [ $exit_code -ne "0" ]
then
  help
  exit 1
else
  "$1" "$2" "$3"
fi
