#!/bin/sh
#
# Install global npm modules

MODULES="create-react-app serverless"

for module in $MODULES; do
  echo "› npm install -g $module"
  npm install -g ${module}@latest
done
