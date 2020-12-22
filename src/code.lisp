(defklass col    ()    (pos 0) (txt "") (n 0) (w 1))
(defklass sym    (col) seen (most 0) mode)
(defklass sample (col) ok l (max (my sample max)))
(defklass skip  (col))

(defun col+ (&key (isa 'num) (pos 0) (txt ""))
  (let ((tmp (make-instance isa :txt txt :pos pos)))
    (setf  (? tmp w) (if  (has 'less txt) -1 1))
    tmp))

(defmethod add ((i col) x)
  (unless (equal x "?")
    (incf (? i n))
    (add1 i x))
  x)

(defmethod add1 ((i skip) x) x) 

(defmethod add1 ((i sym) x)
  (with-slots (seen most mode) i
    (let* ((a   (assoc! x seen :if-needed 0))
           (now (incf (cdr  a))))
      (if (> now most)
        (setf most now
              mode x)))))

; (defmethod add ((i num) x)
;   (with-slots (ok l max)
;     (cond ((< (length l) max) (setf ok nil) (push x l))
;           ((= (length l) max) (setf ok nil) (push x l) (sort l #<))
;           (t 1))))

(dotimes (_ 100) (print (randf 1)))
