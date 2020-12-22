; vim: ts=2 sw=2 sts=2  et :

(defvar *my*
  '(files ("lib" "code")
    ch (     skip  #\?
               less  #\<
               more  #\>
               num   #\$
               klass #\!)
    sample (   max 128
               step .5
               cohen .3
               trivial 1.05)
    id -1
    seed 1
    yes   (    it ""
               pass 0
               fail 0)))

(defmacro my (a b) `(getf (getf *my* ',a) ',b))

(dolist (file (getf *my* 'files))
  (handler-bind ((style-warning #'muffle-warning))
    (load file)))

