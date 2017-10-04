#!/bin/sh
#
# Install global npm modules

MODULES="react-native-cli"

for module in $MODULES; do
  echo "› npm install -g $module"
  npm install -g ${module}@latest
done
