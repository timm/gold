(defmacro ? (obj f &rest fs)
  (if fs `(? (slot-value ,obj ',f) ,@fs) `(slot-value ,obj ',f)))

(defun has (c s) 
  (find (getf (getf *my* 'ch) c)  s :test #'equal))

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

(defun oo (it &optional (pre "")) (format t "~a~%" (o it pre)))

(defun o (it &optional (pre ""))
  (let* ((slots
           (remove-if
             #'(lambda (x) (and (symbolp x)
                                (equal (elt (symbol-name x) 0) #\_)))
             (mapcar #'sb-mop:slot-definition-name 
                     (sb-mop:class-slots (class-of it)))))
         (lst (mapcar
                #'(lambda (s) (list s (slot-value it s)))
                (sort slots  #'string<))))
    (format nil "~a#<~a~{ ~a~}>#" pre (class-name (class-of it)) lst)))

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
