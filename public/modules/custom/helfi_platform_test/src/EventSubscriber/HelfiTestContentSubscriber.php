<?php

declare(strict_types = 1);

namespace Drupal\helfi_platform_test\EventSubscriber;

use Drupal\Core\Extension\ModuleHandlerInterface;
use Drupal\Core\Extension\ModuleInstallerInterface;
use Drupal\helfi_api_base\EventSubscriber\DeployHookEventSubscriberBase;
use Symfony\Contracts\EventDispatcher\Event;

/**
 * Handles post deploy tasks.
 */
final class HelfiTestContentSubscriber extends DeployHookEventSubscriberBase {

  /**
   * Constructs a new instance.
   *
   * @param \Drupal\Core\Extension\ModuleHandlerInterface $moduleHandler
   *   The module handler service.
   * @param \Drupal\Core\Extension\ModuleInstallerInterface $moduleInstaller
   *   The module installer service.
   */
  public function __construct(
    private ModuleHandlerInterface $moduleHandler,
    private ModuleInstallerInterface $moduleInstaller,
  ) {
  }

  /**
   * {@inheritdoc}
   *
   * Install helfi_test_content manually as the installation will fail due
   * to unresolved race condition during site install.
   *
   * The event is triggered by 'drush helfi:post-deploy'
   * command as part of deployment tasks.
   */
  public function onPostDeploy(Event $event) : void {

    if (!$this->moduleHandler->moduleExists('helfi_test_content')) {
      $this->moduleInstaller->install(['helfi_test_content']);
    }

  }

}
