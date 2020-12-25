; vim: noai:ts=2:sw=2:et:
(defun worker (mid top x)
  "If a string, the print x. Else, if defklass,
  start a new section. Else, for defun defmethod and
  defmacro, print their doc string."
  (typecase x
    (string (format mid "~%~a~%" x))
    (cons   (case (first x)
              (defklass 
                (format mid "~%## ~(~S~)~%~%" (second x)))
              ((defun defmethod defmacro)
               (when (stringp (fourth x))
                 (format 
                   mid "~%### ~(~S~)~%~%`~(~S~)` _(~a)_ ~a~%~%" 
                   (second x)
                   `(,(second x) ,@(third x))
                   (subseq (symbol-name (first x)) 2)
                   (fourth x))))))))

(let (x)
  (format t "~a" 
    (with-output-to-string (mid)
      (format t "~a"  
        (with-output-to-string (top) 
          (loop 
            while (setf x (read-preserving-whitespace t nil))
            do (worker mid top x)))))))
