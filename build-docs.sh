#!/bin/sh

jazzy \
  --clean \
  --author "Jonathan Crooke" \
  --github_url https://github.com/itsthejb/CollectionBinarySearch \
  --module-version 1.0 \
  --xcodebuild-arguments -scheme,CollectionBinarySearch \
  --module CollectionBinarySearch \
  --readme README.md
