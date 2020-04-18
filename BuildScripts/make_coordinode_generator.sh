#!/bin/bash

set -e

PROJECT_FILE=../CoordiNode.xcodeproj
SCHEME_NAME=CoordiNodeGenerator

outputDir=$1
buildDir="$(xcodebuild -project $PROJECT_FILE -scheme $SCHEME_NAME -showBuildSettings | grep  -m 1 'BUILD_DIR' | grep -oEi '\/.*')"

xcodebuild                              \
  -project $PROJECT_FILE                \
  -scheme $SCHEME_NAME                  \
  -sdk macosx                           \
  build                                 \
  CONFIGURATION_BUILD_DIR="$buildDir"
  
cp $buildDir/$SCHEME_NAME $outputDir
