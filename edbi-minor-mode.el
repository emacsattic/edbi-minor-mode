(defvar-local edbi-minor-mode-connection nil "")

(defvar-local edbi-minor-mode-result-buffer nil "")

(setq edbi-minor-mode-connection (buffer-local-value 'edbi:connection (get-buffer "*edbi-dbviewer*")))

(setq edbi-minor-mode-result-buffer (get-buffer-create "*edbi-minor-mode-result*"))

(defun edbi-minor-mode-execute (sql)
  (edbi:dbview-query-execute edbi-minor-mode-connection sql edbi-minor-mode-result-buffer))

(edbi-minor-mode-execute (buffer-substring-no-properties (point-min) (point-max)))
