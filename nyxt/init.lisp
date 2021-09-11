(defvar *my-search-engines* nil)
(setf *my-search-engines*
      (list
       '("google" "https://www.google.com/search?q=~a" "https://www.google.com/")
       '("duckduckgo" "https://www.google.com/search?q=~a" "https://www.google.com/")
       '("duckduckgo2" "https://www.google.com/search?q=~a" "https://www.google.com/")))

(prin1-to-string *my-search-engines*)

(define-configuration browser
  ((search-engines (append (mapcar (lambda (x)
                                     (make-instance 'search-engine
                                                    :shortcut (first x)
                                                    :search-url (second x)
                                                    :fallback-url (third x)))
                                   *my-search-engines*)
                           %slot-default))))
