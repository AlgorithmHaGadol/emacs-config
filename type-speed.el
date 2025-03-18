(define-minor-mode typing-speed-mode
    "Displays your typing speed in the status bar."
  :group 'typing-speed
  (if typing-speed-mode
      (progn
        (add-hook 'post-command-hook 'typing-speed-post-command-hook)
	(typing-speed-mode-line)
        (setq typing-speed-event-queue '())
        (setq typing-speed-update-timer (run-with-timer 0 typing-speed-update-interval 'typing-speed-update)))
      (progn
        (remove-hook 'post-command-hook 'typing-speed-post-command-hook)
        (cancel-timer typing-speed-update-timer))))

(defun typing-speed-mode-line ()
  (unless (assoc 'typing-speed-mode mode-line-misc-info)
    (push '(typing-speed-mode (" " typing-speed-mode-text))
	  (cdr (last mode-line-misc-info))))
  (typing-speed-update))

(defcustom typing-speed-window 5
  "The window (in seconds) over which typing speed should be evaluated."
  :group 'typing-speed)

(defcustom typing-speed-mode-text-format " [%s/%s WPM]"
  "A format string that controls how the typing speed is displayed in the mode line.
Must contain at least one %s delimeter. Typing speed will be inserted at the first
delimiter, and peak typing speed at the second."
  :group 'typing-speed)

(defcustom typing-speed-update-interval 1
  "How often the typing speed will update in the mode line, in seconds.

It will always also update after every command."
  :group 'typing-speed)

(defvar typing-speed-mode-text (format typing-speed-mode-text-format 0 0))
(defvar typing-speed-event-queue '())
(defvar typing-speed-update-timer nil)
(defvar typing-speed-peak-speed 0)
(defvar typing-speed-previous-mode-text "")

(make-variable-buffer-local 'typing-speed-peak-speed)
(make-variable-buffer-local 'typing-speed-previous-mode-text)
(make-variable-buffer-local 'typing-speed-mode-text)
(make-variable-buffer-local 'typing-speed-event-queue)

(defun typing-speed-post-command-hook ()
  "When typing-speed-mode is enabled, fires after every command. If the
command is self-insert-command, log it as a keystroke and update the
typing speed."
  (cond ((eq this-command 'self-insert-command)
         (let ((current-time (float-time)))
          (push current-time typing-speed-event-queue)
          (typing-speed-update)))
        ((member this-command '(delete-backward-char backward-delete-char-untabify))
         (progn
           (pop typing-speed-event-queue)
           (typing-speed-update)))))

(defun typing-speed-update ()
  "Calculate and display the typing speed."
  (let ((current-time (float-time)))
    (setq typing-speed-event-queue
          (typing-speed-remove-old-events
           (- current-time typing-speed-window)
           typing-speed-event-queue))
    (typing-speed-message-update)))

(defun typing-speed-message-update ()
  "Updates the status bar with the current typing speed"
  (let* ((chars-per-second (/ (length typing-speed-event-queue) (float typing-speed-window)))
         (chars-per-min (* chars-per-second 60))
         (words-per-min (/ chars-per-min 5)))
    (setq typing-speed-peak-speed (max words-per-min typing-speed-peak-speed))
    (setq typing-speed-mode-text
          (if (minibufferp (current-buffer))
              ""
              (format typing-speed-mode-text-format (floor words-per-min) (floor typing-speed-peak-speed))))
    ;; Attempt to prevent unnecessary flicker in the menu bar. Doesn't seem to help, though.
    (if (not (string-equal typing-speed-mode-text typing-speed-previous-mode-text))
        (progn
          (setq typing-speed-previous-mode-text typing-speed-mode-text)
          (force-mode-line-update)))))


(defun typing-speed-remove-old-events (threshold queue)
  "Removes events older than than the threshold (in seconds) from the specified queue"
  (if (or (null queue)
          (> threshold (car queue)))
      nil
      (cons (car queue)
            (typing-speed-remove-old-events threshold (cdr queue)))))

(defun turn-on-typing-speed ()
  "Turns on typing-speed-mode"
  (if (not typing-speed-mode)
      (typing-speed-mode)))

(defun turn-off-typing-speed ()
  "Turns off typing-speed-mode"
  (if typing-speed-mode
      (typing-speed-mode)))

(typing-speed-mode-line)
