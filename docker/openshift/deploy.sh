#!/bin/sh
#
# Make sure we have active Drupal configuration.
if [ ! -f "../conf/cmi/system.site.yml" ]; then
  output_error_message "Container start error: Codebase is not deployed properly. Exiting early."
  exit 1
fi

if [ ! -n "$OPENSHIFT_BUILD_NAME" ]; then
  output_error_message "Container start error: OPENSHIFT_BUILD_NAME is not defined. Exiting early."
  exit 1
fi

  # Put site in maintenance mode
  drush state:set system.maintenance_mode 1 --input-format=integer

  if [ $? -ne 0 ]; then
    output_error_message "Deployment failed: Failed to enable maintenance_mode"
    exit 1
  fi

drush helfi:pre-deploy || true
# Run maintenance tasks (config import, database updates etc)
drush deploy

if [ $? -ne 0 ]; then
  output_error_message "Deployment failed: drush deploy failed with {$?} exit code. See logs for more information."
  exit 1
fi
# Run helfi specific post deploy tasks. Allow this to fail in case
# the environment is not using the 'helfi_api_base' module.
# @see https://github.com/City-of-Helsinki/drupal-module-helfi-api-base
drush helfi:post-deploy || true
# Disable maintenance mode
drush state:set system.maintenance_mode 0 --input-format=integer

if [ $? -ne 0 ]; then
  output_error_message "Deployment failure: Failed to disable maintenance_mode"
fi
