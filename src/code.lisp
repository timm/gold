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

(defmethod add1 ((i sample) x)
  (with-slots (ok l max) i
    (cond ((< (length l) max) 
           (push x l) 
           (setf ok nil))
          ((< (randi) (/ max (length l))) 
           (setf (nth (randi (length l)) l) x) 
           (setf ok nil)))))

(defmethod items ((i sample))
  (with-slots (ok l) i
    (unless ok
      (setf ok t)
      (sort (? i l) #'<))
    l))

; add optionals lo hi
(defmethod mid  ((i sample)) (per i .5))
(defmethod sd   ((i sample)) (/ (- (per i .9) (per i .1)) 2.56))
(defmethod per ((i sample) &optional (p 0.5) (lo 0) (hi (length (? i l))))
  (nth (floor (+ lo (* p (- hi lo)))) (items i)))


