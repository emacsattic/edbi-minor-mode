(require 'edbi)

(defvar-local edbi-minor-mode-connection nil "")

(defvar-local edbi-minor-mode-result-buffer nil "")

(defvar edbi-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [remap sql-send-buffer] 'edbi-minor-mode-execute-buffer)
    (define-key map [remap sql-send-paragraph] 'edbi-minor-mode-execute-paragraph)
    (define-key map [remap sql-send-region] 'edbi-minor-mode-execute-region)
    (define-key map [remap sql-send-string] 'edbi-minor-mode-execute)
    map)
  "")

(define-minor-mode edbi-minor-mode
  ""
  :lighter " Edbi")

(defun edbi-minor-mode-execute (sql)
  ""
  (interactive "sSQL: ")
  (unless edbi-minor-mode-connection
    (setq edbi-minor-mode-connection
          (buffer-local-value 'edbi:connection
                              (get-buffer edbi:dbview-buffer-name))))
  (unless edbi-minor-mode-result-buffer
    (setq edbi-minor-mode-result-buffer
          (get-buffer-create
           (generate-new-buffer-name "*edbi-minor-mode-result*"))))
  (edbi:dbview-query-execute
   edbi-minor-mode-connection
   sql
   edbi-minor-mode-result-buffer))

(defun edbi-minor-mode-execute-paragraph ()
  ""
  (interactive)
  (let* ((start (save-excursion
                  (backward-paragraph)
                  (point)))
         (end (save-excursion
                (forward-paragraph)
                (point)))
         (sql (buffer-substring-no-properties start end)))
    (edbi-minor-mode-execute sql)))

(defun edbi-minor-mode-execute-region (start end)
  ""
  (interactive "r")
  (let ((sql (buffer-substring-no-properties start end)))
    (edbi-minor-mode-execute sql)))

(defun edbi-minor-mode-execute-buffer ()
  ""
  (interactive)
  (let ((sql (buffer-substring-no-properties (point-min) (point-max))))
    (edbi-minor-mode-execute sql)))
