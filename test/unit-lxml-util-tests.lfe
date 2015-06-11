(defmodule unit-lxml-util-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest ->int
  (is-equal 7 (lxml-util:->int 7))
  (is-equal 7 (lxml-util:->int "7"))
  (is-equal 'atom (lxml-util:->int 'atom)))

(deftest rdecons
  (is-equal '((1 2 3 4 5) 6)
            (lxml-util:rdecons '(1 2 3 4 5 6))))

(deftest rcar
  (is-equal 6 (lxml-util:rcar '(1 2 3 4 5 6))))

(deftest rcdr
  (is-equal '(1 2 3 4 5)
            (lxml-util:rcdr '(1 2 3 4 5 6))))
