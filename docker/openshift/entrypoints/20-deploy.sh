#!/bin/bash

cd /var/www/html/public

function output_error_message {
  echo ${1}
  php ../docker/openshift/notify.php "${1}" || true
}

# Make sure we have active Drupal configuration.
if [ ! -f "../conf/cmi/system.site.yml" ]; then
  output_error_message "Container start error: Codebase is not deployed properly. Exiting early."
  exit 1
fi

if [ ! -n "$OPENSHIFT_BUILD_NAME" ]; then
  output_error_message "Container start error: OPENSHIFT_BUILD_NAME is not defined. Exiting early."
  exit 1
fi

function get_deploy_id {
  echo $(drush state:get deploy_id)
}

# Populate twig caches.
if [ ! -d "/tmp/twig" ]; then
  drush twig:compile || true
fi

