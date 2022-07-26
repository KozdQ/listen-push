#!/usr/bin/env bash
set -e

find_latest_version() {
  local version
  version=$(git describe --tags | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
  if [ -z "$version" ]; then
    echo 0.0.0
  else
    echo "$version"
  fi
}

increment_major() {
  local version major
  version=$(find_latest_version)
  major=${version%%.*}
  NEXT_VERSION="$((major + 1)).0.0"
  write_update 'major'
}

increment_minor() {
  local version major minor
  version=$(find_latest_version)
  major=${version%%.*}
  no_major=${version#*.}
  minor=${no_major%%.*}
  NEXT_VERSION="${major}.$((minor + 1)).0"
  write_update 'minor'
}

increment_patch() {
  local version major minor patch
  version=$(find_latest_version)
  major=${version%%.*}
  no_major=${version#*.}
  minor=${no_major%%.*}
  patch=${version##*.}
  NEXT_VERSION="${major}.${minor}.$((patch + 1))"
  write_update 'patch'
}

write_update() {
  local search replace
  search="${VERSION}"
  replace="${NEXT_VERSION}"
  case $1 in
  major)
    git tag -a v"$replace" -m "[MAJOR] v$replace $MESSAGE"
    echo "[MAJOR] v$replace $MESSAGE"
    echo "Changelog"
    echo "---------"
    git log --pretty=oneline v"$search"...HEAD
    git push origin --tag
    ;;
  minor)
    git tag -a v"$replace" -m "[MINOR] v$replace $MESSAGE"
    echo "[MINOR] v$replace $MESSAGE"
    echo "Changelog"
    echo "---------"
    git log --pretty=oneline v"$search"...HEAD
    git push origin --tag
    ;;
  patch)
    git tag -a v"$replace" -m "[PATCH] v$replace $MESSAGE"
    echo "[PATCH] v$replace $MESSAGE"
    echo "Changelog"
    echo "---------"
    git log --pretty=oneline v"$search"...HEAD
    git push origin --tag
    ;;
  esac
}

is_changed() {
  local isChanged
  isChanged=$(git log --pretty=oneline v"$VERSION"...HEAD)
  if [ -z "$isChanged" ]; then
    echo "No changes detected"
    exit 1
  fi
}

usage() {
  echo "Usage: $0 {MAJOR | MINOR | PATCH} [-m|--message] <message>"
  echo "Bumps the semantic version field by one for the project."
  exit 1
}

make clean

VERSION=$(find_latest_version)
NEXT_VERSION=$VERSION

is_changed

case $2 in
'-m') ;;
'--message') ;;
*) usage ;;
esac

case $3 in
'') usage ;;
*) MESSAGE=$3 ;;
esac

case $1 in
MAJOR) increment_major ;;
MINOR) increment_minor ;;
PATCH) increment_patch ;;
*) usage ;;
esac
