;;; Package --- Summary

;;; Comentary:
;; Emacs init file responsible for either loading pre-compiled configuration
;; file or tangling and loading a literate org configuration file

;; Don't attempt to find/apply special handlers to files loading during
;; startup.
(let ((file-name-handler-alist nil))
  (if (file-exists-p (expand-file-name "readme.elc" user-emacs-directory))
      (load-file (expand-file-name "readme.elc" user-emacs-directory))
    ;; Otherwise use org-babel to tangle and load the configuration
    (require 'org)
    (org-babel-load-file (expand-file-name "readme.org" user-emacs-directory))))

;;; init.el ends here
