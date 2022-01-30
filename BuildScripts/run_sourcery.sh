#!/bin/bash

set -e

AUTO_MOCKABLE_IMPORTS="
import CoordiNode
"
sourcery                                                                    \
  --sources "$PROJECT_DIR/CoordiNode"                                       \
  --templates "$PROJECT_DIR/CoordiNodeTestComponents/Sourcery/Templates"    \
  --args imports="$AUTO_MOCKABLE_IMPORTS"                                   \
  --output "$PROJECT_DIR/CoordiNodeTestComponents/Sourcery/Output"
