#!/bin/bash

set -e

PROJECT_FILE=../CoordiNode.xcodeproj
SCHEME_NAME=CoordiNodeGenerator

moduleStructureFile=$1
outputDir=$2
buildDir="$(xcodebuild -project $PROJECT_FILE -scheme $SCHEME_NAME -showBuildSettings | grep  -m 1 'BUILD_DIR' | grep -oEi '\/.*')"

xcodebuild                              \
  -project $PROJECT_FILE                \
  -scheme $SCHEME_NAME                  \
  -sdk macosx                           \
  -quiet                                \
  build                                 \
  CONFIGURATION_BUILD_DIR="$buildDir"

$buildDir/$SCHEME_NAME                  \
  "$moduleStructureFile"                \
  "$outputDir"
