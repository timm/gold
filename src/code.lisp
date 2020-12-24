; vim: noai:ts=2:sw=2:et:

(defklass col    (thing)    (pos 0) (txt "") (n 0) (w 1))
(defklass sym    (col) seen (most 0) mode)
(defklass sample (col) ok l (max (my sample max)) bins)
(defklass skip  (col))

(defun col+ (&key (isa 'sym) (pos 0) (txt ""))
  (let ((tmp (make-instance isa :txt txt :pos pos)))
    (setf  (? tmp w) (if  (has txt :less ) -1 1))
    tmp))

(defmethod add ((i col) x)
  (unless (equal x "?")
    (incf (? i n))
    (add1 i x))
  x)

(defmethod norm ((i col) x)
  (if (equal x "?") x (norm1 i x)))

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

; add optionals lo hi
(defmethod mid  ((i sample)) (per i .5))
(defmethod mix  ((i sample)) (/ (- (per i .9) (per i .1)) 2.56))
(defmethod per ((i sample) &optional (p 0.5) (lo 0) (hi (length (? i l))))
  (nth (floor (+ lo (* p (- hi lo)))) (items i)))

(defmethod mix((i sym))
 (let ((ent 0))
  (loop for (key . val) in (? i seen) 
    (when (> val 0)
      (let ((p (/ val (? i n))))
       (decf ent (* p (log p))) )))
  ent))

(let ((s (make-sym)))
  (dolist (a '(a b c d e f))
     (add s a))
  (print (mix s)))

(defmethod items ((i sample))
  (with-slots (ok l) i
    (unless ok
      (setf ok t)
      (sort (? i l) #'<))
    l))

(defmethod norm1 ((i col) x ) x)
(defmethod norm1 ((i sample) x ) 
  (min 1 (max 0 
              (/ (x - (per i 0) 
                    (- (per i 1) (per i 0) x) 1E-32)))))

(defmethod split ((i sample))
  (let*((a   (items i))
        (all (length a))
        (eps (* (sd i) (my  sample cohen)))
        (n   (expt all  (my sample step))))
    (loop while (and (< n 4) (< n (/ all 2))) do
          (setf n (* 1.2 n)))
    (setf n (floor n))
    (let (out (lo 0) (b4 0) (hi n) (xlo (nth 0 a)))
      (loop while (<= hi (- all n)) do
            (let ((xhi    (nth hi a))
                  (xafter (nth (1+ hi) a))
                  (when  (> (- hi lo) n)
                    (when (not (= xhi xafter))
                      (when (>= (- xhi xlo) eps)
                        (when (or (zerop b4)
                                  (> (- (mid i lo hi) b4) eps))
                          (push xhi (? i bins))
                          (setf b (mid i lo hi)
                                xlo (nth hi a)
                                lo hi
                                hi (+ hi n)))))))))
      (reverse (? i bins)))))

(defmethod discretize ((i sample) x)
  (let ((out -1))
    (dolist (n (? i bins) (1+ out))
      (incf out)
      (if (< x n) (return-from discretize out)))))
