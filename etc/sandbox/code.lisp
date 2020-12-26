; vim: noai:ts=2:sw=2:et:

"## SYNOPSIS

Store data as table rows. Summarize
columns into table headers

## USAGE

      (fromFile (tbl+) \"xxx.csv\")

## LICENSE

(c) 2020, MIT License, Tim Menzies, timm@ieee.org"


(defklass col    (thing)    (pos 0) (txt "") (n 0) (w 1))

(defun col+ (&key (isa 'sym) (pos 0) (txt ""))
  "Constructor for columns. Sets weights -1,1 if
  `txt` contains '<' or '>' (respectively)."
  (let ((tmp (make-instance isa :txt txt :pos pos)))
    (setf  (? tmp w) (if  (has txt :less ) -1 1))
    tmp))

(defmethod add ((i col) x)
  "Genetic add to column. Ignore missing variables.
   Else increment `n` and call `add1`."
  (unless (equal x "?")
    (incf (? i n))
    (add1 i x))
  x)

(defmethod add1 ((i col) x ) 
  "Default add1 is to do nothing."
  x)

(defmethod norm ((i col) x)
  "If `x` is not missing, then call `norm1`."
  (if (equal x "?") x (norm1 i x)))

(defmethod norm1 ((i col) x ) 
  "Default normalization is to do nothing." 
  x)

;;;;------------------------------------------------------------------
(defklass sym    (col) seen (most 0) mode)

(defmethod add1 ((i sym) x)
  "Update statistics on `x`."
  (with-slots (seen most mode) i
    (let* ((a   (assoc! x seen :if-needed 0))
           (now (incf (cdr  a))))
      (if (> now most)
        (setf most now
              mode x)))))

(defmethod mix((i sym))
  "return entropy"
  (let ((ent 0))
    (loop for (key . val) in (? i seen) do
          (print `(key ,key val ,val))
          (when (> val 0)
            (let ((p (/ val (? i n))))
              (decf ent (* p (log p 2))) )))
    ent))

;;;;------------------------------------------------------------------
(defklass sample (col) ok l (max (my sample max)) bins)

(defmethod add1 ((i sample) x)
  "Update summary on numeric `x`. If contents full, then
   replace anything old, at random, with `x`."
  (with-slots (ok l max) i
    (cond ((< (length l) max) 
           (push x l) 
           (setf ok nil))
          ((< (randi) (/ max (length l))) 
           (setf (nth (randi (length l)) l) x) 
           (setf ok nil)))))

(defmethod mid  ((i sample)) 
  "Return median" 
  (per i .5))

(defmethod mix  ((i sample)) 
  "Return standard deviation."
  (/ (- (per i .9) (per i .1)) 2.56))

(defmethod per ((i sample) &optional (p 0.5) (lo 0) (hi (length (? i l))))
  (nth (floor (+ lo (* p (- hi lo)))) (items i)))

(defmethod items ((i sample))
  "Return contents. Ensure they are sorted."
  (with-slots (ok l) i
    (unless ok
      (setf ok t)
      (sort (? i l) #'<))
    l))

(defmethod norm1 ((i sample) (x number)) 
  "Return `x`, normalizes 0..1 for lo..hi."
  (min 1 (max 0 
              (/ (x - (per i 0) 
                    (- (per i 1) (per i 0) x) 1E-32)))))

(defmethod split ((i sample))
  "Divide contents into bins, of size at least sqrt(size(contents)).
  Ignore iajdacent bins is they are too similar (median difference
  less than 0.3*stdDeviation)."
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

(defmethod discretize ((i sample) (x number))
  "Divide `x` into bins."
  (let ((out -1))
    (dolist (n (? i bins) (1+ out))
      (incf out)
      (if (< x n) (return-from discretize out)))))
;;;;------------------------------------------------------------------
(defklass skip   (col))

;;;;------------------------------------------------------------------
(defklass row    (thing) (dom 0) cells)

(defun row+ (lst tbl &aux (r (make-instance 'row)))
  "Constructor for rows. As a side-effect, update table
  column summaries."
  (setf (? r cells) (mapcar #'add (? tbl cols) lst))
  r)


;;;;------------------------------------------------------------------
(defklass tbl    (thing) xs ys rows cols)

(defun tbl+ (&optional rows &aux (tbl (make-instance 'tbl)))
  "Constructor for tables. If given `rows` then add those in."
  (dolist (row rows tbl) (add tbl row)))

(defmethod add ((i tbl) (r row)) (add i (? r cells)))
(defmethod add ((i tbl) (lst cons)) 
  "Add one row to a table. If this is the first row, then
  initialize the headers. Else add as data."
  (with-slots (cols rows) i
    (if cols
      (push (row+ lst i) rows)
      (setf cols (cols+ i lst)))))

(defmethod dom ((i tbl) &aux (s (make-instance 'sym)))
  "Compared to a random sample of other rows,
   count how often one row dominates the others."
  (dolist (row1 (? i rows))
    (dotimes (n (my tbl samples))
      (incf (dom row1 (if (one (? i rows)) 1 0))))
    (add s (? row1 dom)))
  (dolist (row1 (? i rows) (length (? i bins)))  
    (setf (? row1 y) (bin s (? row1 dom)))))
   
(defmethod cols+ ((i tbl) lst &aux (n 0))
  "Constructor for columns in a table."
  (labels ((what (txt) (if (has txt :less :more :num) 'sample 'sym)))
    (mapcar #'(lambda (x) (col+ :isa (what x):pos (incf n) :txt x)) 
            lst)))

(defmethod fromFile ((i tbl) file)
  "Initialize table from disk."
  (with-csv (lst file i) (add i lst)))
