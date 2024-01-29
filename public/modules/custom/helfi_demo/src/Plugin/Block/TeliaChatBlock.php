<?php

declare(strict_types = 1);

namespace Drupal\helfi_demo\Plugin\Block;

use Drupal\Core\Block\BlockBase;

/**
 * Block for telia chat.
 *
 * @Block(
 *   id = "telia_chat_block",
 *   admin_label = @Translation("Telia Chat Block"),
 * )
 */
class TeliaChatBlock extends BlockBase {

  /**
   * {@inheritdoc}
   */
  public function build(): array {
    return [
      '#markup' => '<a href="//acewebsdk/local-chat-info-fin">Chat</a>',
      '#attached' => [
        'library' => [
          'helfi_demo/telia_chat_websdk',
        ],
      ],
    ];
  }

}
