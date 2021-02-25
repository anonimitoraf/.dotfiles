#!/usr/bin/env bash
set -euo pipefail

emacsclient -c \
  --eval "(dired default-directory)" \
  --eval "(defun kill-window-or-emacs () (interactive) (if (one-window-p) (kill-emacs) (delete-window)))" \
  --eval "(setq dired-dwim-target t delete-by-moving-to-trash t)" \
  --eval "(define-key dired-mode-map (kbd \"q\") #'kill-window-or-emacs)"
