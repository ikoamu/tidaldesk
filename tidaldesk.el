(require 'neotree)
(require 'hydra)

;; /path/to/tidaldesk
(defvar tidaldesk-dir "~/../../tidaldesk")
(defvar tidaldesk-top-path (concat tidaldesk-dir "/README.org"))
;; /path/to/Dirt-Samples
(defvar tidaldesk-dirt-samples-dir
  (expand-file-name
   (concat "~/../.." "/AppData/Local/SuperCollider/downloaded-quarks/Dirt-Samples")))

;;
;; Open TidalDesk
;;
(defun tidaldesk-open-desk ()
  (interactive)
  (find-file tidaldesk-top-path)
  (neotree-dir tidaldesk-dir))

;;
;; SuperCollider
;;
;; Prerequisite: `scide` and `sclang` paths must be set.
;;
(defun tidaldesk-execute-scide-with-file (file)
  (interactive "Open SuperCollider IDE: ")
  (shell-command
   (format "scide %s &" (shell-quote-argument (expand-file-name file)))
   "*SC IDE*"))

(defun tidaldesk-open-scide ()
  (interactive "Open SuperCollider IDE: ")
  (shell-command (format "scide &")
		 "*SC IDE*"))

(defun tidaldesk-open-scide-with-file ()
  (interactive)
  (tidaldesk-execute-scide-with-file (read-file-name "SCD File: ")))

;; 
;; Dirt-Samples neotree setting
;; See from https://github.com/jaypei/emacs-neotree/issues/77
;;
(defun neo-open-file-hide (full-path &optional arg)
  "Open file and hiding neotree.
The description of FULL-PATH & ARG is in `neotree-enter'."
  (neo-global--select-mru-window arg)
  (find-file full-path)
  (neotree-hide))

(defun neotree-enter-hide (&optional arg)
  "Neo-open-file-hide if file, Neo-open-dir if dir.
The description of ARG is in `neo-buffer--execute'."
  (interactive "P")
  (neo-buffer--execute arg 'neo-open-file-hide 'neo-open-dir))

(defun open-dirt-samples ()
  (interactive)
  (neo-global--open-dir tidaldesk-dirt-samples-dir))

(defun tidaldesk-dirt-samples-toggle ()
  "Toggle show the NeoTree window."
  (interactive)
  (if (neo-global--window-exists-p)
      (neotree-hide)
    (open-dirt-samples)))

;;
;; Org-babel execute tidalcycles
;;
(defun org-babel-execute:tidal (body params) "test"
  (interactive)
  ;; TODO: tidalを起動していない場合は起動する(yes or noもほしい)
  (tidal-send-string ":{")
  (tidal-send-string body)
  (tidal-send-string ":}")
  "ok")

;;
;; Hydra
;;
;; (bind-key
;;  "<f12>"
;;  (defhydra hydra-tidaldesk (:color pink :hint nil)
;;    "
;; _f12_: to-top"
;;      ("<f12>" tidaldesk-open-desk "to-desk")))


(defhydra hydra-outline (:color pink :hint nil :exit t)
  "
^Hide^
^^^^^^------------------------------------------------------
_t_: todesk

"
  ("t"  tidaldesk-open-desk))

(global-set-key (kbd "<f12>") 'hydra-outline/body) ; by example

(provide 'tidaldesk)

