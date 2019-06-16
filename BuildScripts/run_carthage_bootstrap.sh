#!/bin/bash

carthage bootstrap Nimble Quick     \
  --project-directory ..            \
  --platform iOS                    \
  --cache-builds

carthage bootstrap Yams             \
  --project-directory ..            \
  --platform macOS                  \
  --cache-builds
