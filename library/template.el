;; die hier einfügen, sagen, dass wir die global brauchen
(setq protocol/contacts '())
(setq protocol/title "")
(setq protocol/date "")

;; fange an zu schreiben, bis kommentar,
;; - dann erklären: switch to buffer.
;; - dann kopieren

(defun protocol/protocol ()
  "Opens a new buffer with protocol-minor-mode enabled."
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
    (insert "* Protokoll\n\n")))


;; Komplett von Hand schreiben, erst
;; OHNE SAVE EXCURSION
;; dann mit
;; dann mit name als parameter
(defun protocol/goto-anwesende ()
  (save-excursion
    (goto-line 7)
    (insert "- ")
    (insert "Kaan")
    (newline)
    (newline)))

;;; JETZT WOLLEN WIR EINEN KONTAKT SUCHEN UND EINFÜGEN
;; das hier komplett einfügen
;; With help from: http://pragmaticemacs.com/emacs/tweaking-email-contact-completion-in-mu4e/

(defun protocol/select-and-insert-contact ()
  (interactive)
  (let (contacts-list contact)
    (setq contacts-list (hash-table-keys mu4e~contacts))
    (setq contact

          ...

          )
    (unless (equal contact "")
      contact)))

;; dann bei ... das hier einfügen

(ivy-read "Contact: "
          (list "Kaan Sahin" "Tobias Paulus " "Michael Sperber")
          :re-builder #'ivy--regex
          :sort nil)

;; JETZT FÜGEN WIR DAS HINSPRINGEN ZU ANWESENDE UND DAS AUSWÄHLEN VOM
;; KONTAKT ZUSAMMEN
;;- dazu erstmal goto-anwesende umschreiben, dass es eine Funktion ausführt
(defun protocol/add-contact ()
  (interactive)
  (protocol/goto-anwesende 'protocol/select-and-insert-contact))

(protocol/add-contact)

;; JETZT WOLLEN WIR NOCH EINE FUNKTIONALITÄT EINFÜGEN:
;; ES SOLL MÖGLICH SEIN, MAILS ZU VERSCHICKEN AN DIE ANWESENDEN

;; Das ganze kopieren
(defun protocol/compose-mail ()
  "Inserts buffer content and contacts into a compose-mail buffer"
  (interactive)
  (mark-page)
  (kill-ring-save (point-min) (point-max))
  (compose-mail-other-window)

  ;; (protocol/insert-contacts protocol/contacts)

  (goto-line 2)
  (move-end-of-line 1)
  (insert "Protokoll vom " protocol/date ": " protocol/title)
  (goto-line 5)
  (insert "Hallo zusammen,\n\nanbei das Protokoll vom Meeting heute.")
  (insert "\n\nFreundliche Grüße\n\nKaan Sahin\n\n----\n\n")
  (yank))

;; JETZT WOLLEN WIR, DASS DIE KONTAKTE AUS ANWESENDE OBEN ERSCHEINEN,
;; DAZU MÜSSEN WIR DIE UNS IN EINER LISTE SPEICHERN
;; Jetzt Kontakt zur Kontaktliste hinzufügen in select-and-insert
(setq protocol/contacts (cons contact protocol/contacts))

;; Liste zeigen

;; Dann Funktion schreiben, die die Kontaktliste in den Buffer
;; schreibt. Alles von HAND schreiben
(defun protocol/insert-contacts (contacts)
  (require 'seq)
  (let ((contacts-string (seq-reduce (lambda (acc c) (concat c "," acc))
                                     contacts
                                     "")))
    (insert contacts-string)))

;; Dann das hier oben bei compose-mail einfügen
(protocol/insert-contacts protocol/contacts)

;; minor mode definieren, Template kopieren
(define-minor-mode protocol-mode
  "This is a minor mode for writing a protocol in org-mode"
  :lighter " Protokoll"

  )

;; Dann Keymap selbst reinschreiben
(define-minor-mode protocol-mode
  "This is a minor mode for writing a protocol in org-mode"
  :lighter " Protokoll"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-m") 'protocol/compose-mail)
            (define-key map (kbd "C-c C-a") 'protocol/add-contact)
            map))

;; Dann beim Aufruf von protocol/protocol den Mode aktivieren:

;; (protocol-mode)
