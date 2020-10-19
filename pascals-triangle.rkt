#lang racket
(require json)
(require racket/cmdline)

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

(define to (command-line #:args (number-of-levels) (string->number number-of-levels)))

(write-json
  (reverse (for/fold
    (
      ; The list needs to have a number in position 0 for the chart to display correctly
      [points '(-1)]
      [current-level '()]
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

      (let*-values (
        [(next-level) (next-triangle-level current-level)]
        [(count total) (percentage-of next-level odd?)]
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
