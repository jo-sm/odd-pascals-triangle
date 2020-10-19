#lang racket
(require json)

(define (next-triangle-level current-level)
  (define (iter result remaining)
    (cond
      ((eq? (length remaining) 0) result)
      ((eq? (length remaining) 1) (cons 1 result))
      (else (iter (cons (+ (car remaining) (car (cdr remaining))) result) (cdr remaining)))
    )
  )

  (iter '(1) current-level)
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

(define check-fn odd?)

(write-json
  (reverse (for/fold
    (
      [points (list (if (check-fn 1) 100.0 0))]
      [current-level '()]
      [running-count 0]
      [running-total 0]
      #:result points
    )
    ([i (range 0 1500)])
    ((lambda () (begin
      (display ".")
      (flush-output)

      (let*-values (
        [(next-level) (next-triangle-level current-level)]
        [(count total) (percentage-of next-level check-fn)]
      )
        (values
          (cons (* 100.0 (/ (+ running-count count) (+ running-total total))) points)
          next-level
          (+ running-count count)
          (+ running-total total)
        )
      )
    )))
  ))
  (open-output-file "odd.json" #:exists 'replace)
)

(displayln "")
