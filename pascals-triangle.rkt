#lang racket
(require json)
(require racket/cmdline)

(define (triangle-level n)
  (foldl
    (lambda (a result) (cons (/ (* (car result) (+ a 1)) (- n a)) result))
    '(1)
    (reverse (range 0 n))
  )
)

(define (percentage-of lst fn)
  (define (iter count total items)
    (cond
      ((eq? empty items) (values count total))
      ((fn (car items)) (iter (+ count 1) (+ total 1) (cdr items)))
      (else (iter count (+ total 1) (cdr items)))
    )
  )

  (iter 0 0 lst)
)

(define to (command-line #:args (number-of-levels) (string->number number-of-levels)))

(write-json
  (reverse (for/fold
    (
      ; The list needs to have a number in position 0 for the chart to display correctly
      [points '(-1)]
      [running-count 0]
      [running-total 0]
      #:result points
    )
    ([i (range 0 (+ to 1))])
    ((lambda () (begin
      (display "\r")
      (display i)
      (display "/")
      (display to)
      (flush-output)

      (let-values (
        [(count total) (percentage-of (triangle-level i) odd?)]
      )
        (values
          (cons (* 100.0 (/ (+ running-count count) (+ running-total total))) points)
          (+ running-count count)
          (+ running-total total)
        )
      )
    )))
  ))
  (open-output-file "odd.json" #:exists 'replace)
)

(displayln "")
