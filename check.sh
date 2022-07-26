#!/usr/bin/env bash
set -e

printf '\n'

check_dependencies() {
  if ! command -v go &>/dev/null; then
    echo "go is not installed."
    exit 1
  fi
  if ! command -v curl &>/dev/null; then
    echo "curl is not installed."
    exit 1
  fi
  if ! command -v docker &>/dev/null; then
    echo "docker is not installed."
    exit 1
  fi
}

check_dependencies
echo "all ok"