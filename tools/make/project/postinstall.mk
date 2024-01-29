DRUPAL_NEW_TARGETS += drush-install-test-content

PHONY += drush-install-test-content
drush-install-test-content: ## Install test content.
	$(call step,Install helfi_test_content module...)
	$(call drush,cr)
	$(call drush,en -y helfi_test_content)
