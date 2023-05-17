;;; Package --- Summary

;;; Comentary:
;; Emacs init file responsible for either loading pre-compiled configuration
;; file or tangling and loading a literate org configuration file
(defvar elpaca-installer-version 0.3)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil
                              :files (:defaults (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (call-process "git" nil buffer t "clone"
                                       (plist-get order :repo) repo)))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (kill-buffer buffer)
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Don't attempt to find/apply special handlers to files loading during
;; startup.
(let ((file-name-handler-alist nil))
  (if (file-exists-p (expand-file-name "readme.elc" user-emacs-directory))
      (load-file (expand-file-name "readme.elc" user-emacs-directory))
    ;; Otherwise use org-babel to tangle and load the configuration
    (org-babel-load-file (expand-file-name "readme.org" user-emacs-directory))))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yaml-mode writeroom-mode which-key vertico use-package undo-tree try treemacs-projectile treemacs-magit treemacs-icons-dired treemacs-evil treemacs-all-the-icons toc-org solarized-theme smartparens skewer-mode rust-mode real-auto-save rainbow-mode rainbow-delimiters plantuml-mode org-sticky-header org-ref org-contrib orderless olivetti oer-reveal nand2tetris monokai-theme mo-git-blame marginalia lsp-ui json-mode js2-refactor inf-clojure ido-vertical-mode ibuffer-projectile git-modes git-gutter-fringe general flycheck flx-ido exec-path-from-shell evil-org embark-consult diminish diff-hl delight dap-mode counsel company color-theme-sanityinc-solarized color-identifiers-mode cider aggressive-indent)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(error ((t (:inherit nano-face-critical :foreground "black"))))
 '(flycheck-error-list-error ((t nil)))
 '(flycheck-fringe-error ((t nil))))
