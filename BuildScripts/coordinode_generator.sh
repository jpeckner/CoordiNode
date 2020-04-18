#!/bin/bash

set -e

SCHEME_NAME=CoordiNodeGenerator
moduleStructureFile=$1
outputDir=$2

./make_coordinode_generator.sh $(pwd)

$(pwd)/$SCHEME_NAME                  \
  "$moduleStructureFile"                \
  "$outputDir"
  
rm $(pwd)/$SCHEME_NAME
