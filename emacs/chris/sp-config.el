;; smart parens configuration


;; Navigation
(define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
(define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)
(define-key smartparens-mode-map (kbd "C-M-a") 'sp-beginning-of-sexp)
(define-key smartparens-mode-map (kbd "C-M-e") 'sp-end-of-sexp)

(define-key smartparens-mode-map (kbd "C-}") 'sp-down-sexp)
(define-key smartparens-mode-map (kbd "C-{") 'sp-backward-down-sexp)
(define-key smartparens-mode-map (kbd "C-)") 'sp-up-sexp)
(define-key smartparens-mode-map (kbd "C-(") 'sp-backward-up-sexp)

(define-key smartparens-mode-map (kbd "C-M-n") 'sp-next-sexp)
(define-key smartparens-mode-map (kbd "C-M-p") 'sp-previous-sexp)

(define-key smartparens-mode-map (kbd "C-S-b") 'sp-backward-symbol)
(define-key smartparens-mode-map (kbd "C-S-f") 'sp-forward-symbol)
(define-key smartparens-mode-map (kbd "C-S-<backspace>") 'sp-backward-kill-symbol)

;; Editing

(define-key smartparens-mode-map (kbd "C-M-t") 'sp-transpose-sexp)

(define-key smartparens-mode-map (kbd "C-M-(") 'sp-backward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-M-)") 'sp-forward-slurp-sexp)

(define-key smartparens-mode-map (kbd "C-M-{") 'sp-backward-barf-sexp)
(define-key smartparens-mode-map (kbd "C-M-}") 'sp-forward-barf-sexp)

(define-key smartparens-mode-map (kbd "C-M-k") 'sp-kill-sexp)
(define-key smartparens-mode-map (kbd "C-M-d") 'sp-kill-sexp)
(define-key smartparens-mode-map (kbd "C-M-<backspace>") 'sp-backward-kill-sexp)

(define-key smartparens-mode-map (kbd "M-r") 'sp-raise-sexp)
