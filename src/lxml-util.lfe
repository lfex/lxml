(defmodule lxml-util
  (export all))

(defun version ()
  (version 'lxml))

(defun version (app-name)
  (application:load app-name)
  (case (application:get_key app-name 'vsn)
    (`#(ok ,vsn) vsn)
    (default default)))

(defun version-arch ()
  `#(architecture ,(erlang:system_info 'system_architecture)))

(defun version+name (app-name)
  `#(,app-name ,(version app-name)))

(defun versions-rebar ()
  `(,(version+name 'rebar)
    ,(version+name 'rebar3_lfe)))

(defun versions-langs ()
  `(,(version+name 'lfe)
    #(erlang ,(erlang:system_info 'otp_release))
    #(emulator ,(erlang:system_info 'version))
    #(driver ,(erlang:system_info 'driver_version))))

(defun versions ()
  (lists:append `((,(version+name 'lxml))
                  ,(versions-langs)
                  ,(versions-rebar)
                  (,(version-arch)))))

(defun arg->str
  ((arg) (when (is_integer arg))
   (arg->str (integer_to_list arg)))
  ((arg) (when (is_atom arg))
   (arg->str (atom_to_list arg)))
  ((arg) arg))

(defun ->atom
  ((x) (when (is_list x))
   (list_to_atom x))
  ((x) (when (is_integer x))
   (list_to_atom (integer_to_list x)))
  ((x) x))

(defun get-defined
  ;; undefined OS env values will match false
  (((cons 'false rest))
   (get-defined rest))
  ;; undefined INI values will match undefined
  (((cons 'undefined rest))
   (get-defined rest))
  (((cons match _))
   match))

(defun ->int
  ((str) (when (is_list str))
   (list_to_integer str))
  ((x)
   x))

(defun rdecons (list)
  "Reverse de-cons function: instead of head/tail, it returns
  all-but-last/last."
  (let ((`#(,all-but-last ,last) (lists:split (- (length list) 1) list)))
    (list all-but-last (car last))))

(defun rcar (list)
  "Returns the last element."
  (let ((`(,_ ,last) (rdecons list)))
    last))

(defun rcdr (list)
  "Returns all but the last element."
  (let ((`(,all-but-last ,_) (rdecons list)))
    all-but-last))

(defun one-or-all
  "This is for use in filtering results that could either contain a single
  element or a list of elements, returning just the element itself when
  the passed list only has one element."
  ((`(,head . ()))
   head)
  ((all)
   all))