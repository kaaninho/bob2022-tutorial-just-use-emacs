(defun protocol/goto-anwesende (name)
  (save-excursion
    (goto-line 7)
    (insert "- ")
    (insert name)
    (newline)
    (newline)))

(setq protocol/contact-file "/home/kaan/.emacs.dvanilla/.contacts")
(setq protocol/contacts '())
(setq protocol/title "")
(setq protocol/date "")

;; With help from: http://pragmaticemacs.com/emacs/tweaking-email-contact-completion-in-mu4e/

(defun protocol/select-and-insert-contact ()
  (interactive)
  (let (contacts-list contact)
    (setq contacts-list (hash-table-keys mu4e~contacts))
    (setq contact
          (ivy-read "Contact: "
                    contacts-list
                    :re-builder #'ivy--regex
                    :sort nil))
    (unless (equal contact "")
      (setq protocol/contacts (cons contact protocol/contacts))
      contact)))

(defun protocol/add-contact ()
  "Adds a contact to the headline \"Anwesende\""
  (interactive)
  (protocol/goto-anwesende (protocol/select-and-insert-contact)))

(defun protocol/insert-contacts (contacts)
  (require 'seq)
  (let ((contacts-string (seq-reduce (lambda (acc a) (concat a "," acc))
                                     contacts
                                     "")))
    (insert contacts-string)))

(defun protocol/compose-mail ()
  "Inserts buffer content and contacts into a compose-mail buffer"
  (interactive)
  (mark-page)
  (kill-ring-save (point-min) (point-max))
  (compose-mail-other-window)
  (protocol/insert-contacts protocol/contacts)
  (goto-line 2)
  (move-end-of-line 1)
  (insert "Protokoll vom " protocol/date ": " protocol/title)
  (goto-line 5)
  (insert "Hallo zusammen,\n\nanbei das Protokoll vom Meeting heute.")
  (insert "\n\nFreundliche Grüße\n\nKaan Sahin\n\n----\n\n")
  (yank))

(defun protocol/protocol ()
  "Opens a new org buffer with protocol-minor-mode enabled."
  (interactive)
  (setq protocol/title (read-string "Protokoll Überschrift: "))
  (setq protocol/date (format-time-string "%Y-%m-%d"))
  (setq protocol/contacts '())
  (let* ((buffer-name (concat protocol/date "-" protocol/title ".org")))
    (switch-to-buffer buffer-name)
    (org-mode)
    (insert "#+title: " protocol/title "\n")
    (insert "#+date: " protocol/date "\n")
    (insert "#+author: " user-full-name "\n\n")
    (insert "* Anwesende\n\n")
    (insert "* Protokoll\n\n")
    (protocol-mode)))

(define-minor-mode protocol-mode
  "This is a minor mode for writing a protocol in org-mode"
  :lighter " Protokoll"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-m") 'protocol/compose-mail)
            (define-key map (kbd "C-c C-a") 'protocol/add-contact)
            map))
