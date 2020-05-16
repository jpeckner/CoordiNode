#!/bin/bash

set -e

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_FILE=$CURRENT_DIR/../CoordiNode.xcodeproj
RESOURCES_PATH=$CURRENT_DIR/../CoordiNode/Resources
SCHEME_NAME=CoordiNodeGenerator

# Build binary
buildDir="$(xcodebuild -project $PROJECT_FILE -scheme $SCHEME_NAME -showBuildSettings | grep  -m 1 'BUILD_DIR' | grep -oEi '\/.*')"
xcodebuild                              \
  -project $PROJECT_FILE                \
  -scheme $SCHEME_NAME                  \
  -sdk macosx                           \
  build                                 \
  CONFIGURATION_BUILD_DIR="$buildDir"

# Copy binary to RESOURCES_PATH
cp $buildDir/$SCHEME_NAME $RESOURCES_PATH
