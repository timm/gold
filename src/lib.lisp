; vim: noai:ts=2:sw=2:et:
(defmacro ? (obj f &rest fs)
  (if fs `(? (slot-value ,obj ',f) ,@fs) `(slot-value ,obj ',f)))

(defmacro aif (test then &optional else)
   `(let ((it ,test))
          (if it ,then ,else)))

(defmacro has (s &rest cs) 
  (let ((c (gensym)))
    `(dolist (,c ',cs)
       (if (find (getf (getf *my* :ch) ,c)  ,s :test #'equal)
         (return t)))))

(defmacro assoc! (x alist &key if-needed (test #'equal))
  `(or (assoc ,x ,alist :test ,test)
       (car (setf ,alist (cons (cons ,x  ,if-needed) ,alist)))))

(defmacro defklass (class parents &rest slots)
  (labels (
    (up (&rest things) ;list of things => 1 upcase string
        (with-output-to-string(s)
          (dolist (thing things) (format s "~:@(~a~)" thing))))
    (tweak (slot) ;make slot
           (if (atom slot) ;list slots contain initforms
             (defslot (up slot) nil ) 
             (defslot (up (first slot)) (second slot))))
    (defslot (slot init) ;finally, we can do the work
             `(,(intern slot) 
                :initarg  ,(intern slot "KEYWORD")
                :initform ,init
                :accessor ,(intern (up class '- slot)))))
    `(defclass ,class ,parents ,(mapcar #'tweak slots))))

(defklass thing ())

(defmethod print-object ((i thing) str)
  (let* ((slots
           (remove-if
             #'(lambda (x) (and (symbolp x)
                                (equal (elt (symbol-name x) 0) #\_)))
             (mapcar #'sb-mop:slot-definition-name 
                     (sb-mop:class-slots (class-of i)))))
         (lst (mapcar
                #'(lambda (s &aux (x (slot-value i s)))
                    (if x (list s x) (list s)))
                (sort slots  #'string<))))
    (format str "#<~a~{ ~a~}>#"  (class-name (class-of i)) lst)))

(defun symbol< (x y) (string< (symbol-name x) (symbol-name y)))

(let* ((seed0      10013)
       (seed       seed0)
       (multiplier 16807.0d0)
       (modulus    2147483647.0d0))
  (labels ((park-miller ()
             (setf seed (mod (* multiplier seed) modulus))
             (/ seed modulus)))
    (defun reset-seed () (setf seed seed0))
    (defun randf (&optional (n 1)) (* n (- 1.0d0 (park-miller))))
    (defun randi (n)(floor (* n (/ (randf 1000.0) 1000))))))

(defmacro with-csv ((lst file &optional out) &body body)
  `(progn (csv ,file #'(lambda (,lst) ,@body)) ,out))

(defun csv (file fun)
  (labels ((cell (s) (let ((s (read-from-string s)))
                       (if (numberp s) s 
                         (string-trim '(#\newline #\tab #\space) s))))
           (cells (s &optional (x 0) (y (position #\, s :start (1+ x))))
                  (cons (cell (subseq s x y)) 
                        (and y (cells s (1+ y))))))
    (let ((*readtable* (copy-readtable nil)))
      (setf (readtable-case *readtable*) :preserve)
      (with-open-file (str file) 
        (loop 
          (funcall fun (cells (or (read-line str nil)
                                  (return-from csv)))))))))

