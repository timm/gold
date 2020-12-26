; vim: noai ts=2 sw=2 et:

"## SYNOPSIS

Generate Markdown from LISP doc strings.

## USAGE

      cat file.lisp      | sbcl --script docs.lisp
      e.g. cat docs.lisp | sbcl --scropt docs.lisp

## LICENSE

(c) 2020, MIT License, Tim Menzies, timm@ieee.org"

(defun main()
  "Reading from standard input, for each readable thing, 
  show the strings (verbatim). Also,
  for defuns, defmacros, defmethods for doco strings, show their
  (a)~name, (b)~signature, (c)~doc string as well as (d)~write
  the name to a table of contents header.  "
  (let (x
         (fmttoc "~%~%<br clear=all>~%~%--------~%~%<img width=100 align=right 
                  src=\"https://sdl-stickershop.line.naver.jp/products/0/0/1/1299646/android/stickers/12120443.png;compress=true\g\">~%~%## ~(~S~)~%~%")
         (fmtbody "~%### ~(~S~)~%~% `~(~S~)` _(~a)_ ~a~%"))
    (format t "~%~a~%" 
      (with-output-to-string (mid)
        (format t "~%~a~%"  
          (with-output-to-string (top) 
            (format top "<img src=\"https://www.lisperati.com/lisplogo_alien_256.png\" align=right>~%~%")
            (loop while (setf x (read-preserving-whitespace t nil)) do
              (typecase x
                (string (format mid "~%~a~%" x))
                (cons   (case (first x)
                          (defklass 
                            (format top "- [~(~S~)](#~(~S~))~%"  
                                    (second x) (second x))
                            (format mid fmttoc (second x)))
                          ((defun defmethod defmacro)
                           (when (stringp (fourth x))
                             (format top "  - [~(~S~)](#~(~S~))~%" 
                                     (second x) (second x))
                             (format mid fmtbody
                                     (second x)
                                     `(,(second x) ,@(third x))
                                     (case (first x)
                                       (defun 'FUN)
                                       (defmacro 'MACRO)
                                       (defmethod 'METHOD))
                                     (fourth x))))))))))))))

(main)
