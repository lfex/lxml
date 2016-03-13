(defmodule lxml
  (export all))

(include-lib "clj/include/compose.lfe")
(include-lib "lxml/include/xml.lfe")

;;; API functions

(defun start ()
  (++ (lhc:start) `(#(lxml ok))))

(defun parse (arg)
  (parse arg '()))

(defun parse
  ((`#(file ,filename) options)
   (case (file:read_file filename)
     (`#(ok ,data)
      (parse-body data options))
     (x x)))
  ((`#(url ,url) options)
   (parse-body (lhc:get url) options))
  ((data options)
   (parse-body data options)))

(defun get-data
  (((= `#(file ,filename) arg))
   (get-data (parse arg)))
  (((= `#(url ,url) arg))
   (get-data (parse arg)))
  ((`#(xml ,xml))
   (get-data (parse-body xml '())))
  ((results)
   (proplists:get_value 'content results)))

(defun get-in
  "get-in assumes that the last element of the three-tuple is the one that holds
  the desired data. As this is the 'content' element of the tuple as parsed by
  erlsom, this is a reasonable assumption.

  To get attributes instead of content, get-in can be used to obtain the
  second-to-last nested value and then the attributes may be extracted from last
  one.

  get-in supports a list of 3-tuples but also a list of 2-tuples which contain
  3-tuples."
  ((keys (= `#(file ,filename) arg))
   (get-in keys (get-data arg)))
  ((keys (= `#(url ,url) arg))
   (get-in keys (get-data arg)))
  ((keys (= `#(xml ,xml) arg))
   (get-in keys (get-data arg)))
  ((keys data) (when (is_tuple data))
   (get-in keys (list data)))
  ;; XXX generalize the following code to a general-purpose map function
  ;; for this library
  (((= `(,first-key . ,rest-keys) keys)
    (= `(,first-data . ,rest-data) data))
   (cond ((=:= (size first-data) 3)
          (get-content keys data))
         ((=:= (size first-data) 2)
          (get-content
            rest-keys
            (element 2 (lists:keyfind first-key 1 data)))))))

(defun get-parent-in
  ;; XXX use this for get-attr-in as well as get-linked (in other words,
  ;; generalize th code in get-linked and move it here
  'noop)

(defun get-attr-in
  'noop)

(defun get-content (keys data)
  (lists:foldl #'find-content/2 data keys))

(defun find-content
  "This is necesary since the proplists module requires 2-tuples only.

  This function assumes that the data desired is in the third (last) element
  of the three-tuple."
  ((key data) (when (is_integer key))
    (lxml-util:one-or-all
      (element 3 (lists:nth key data))))
  ((key data)
    (lxml-util:one-or-all
      (element 3 (lists:keyfind key 1 data)))))

(defun get-linked (keys data)
  (get-linked keys data '()))

(defun get-linked (keys data options)
  "This is a utility function similar to get-in, but instead is intended for use
  with linked REST data (i.e., REST relational data).

  This function will search nested data, assuming:
  * the last key points to a data structure that parsed an XML element with an
    'href' attribute (the link to the desired related REST resource)
  * all but the last key reference nested data structures that should be
    traversed for their contents (i.e., the third element of the 3-tuples) not
    their attributes (the second element of the 3-tuples)"
  (let* ((`(,all-but-last ,last) (lxml-util:rdecons keys))
         (link-data (get-in all-but-last data))
         (url (find-link last link-data)))
    (lhc:get url (++ '(#(endpoint false)) options))))

(defun get-link-in-3tuple (keys data)
  (lists:foldl #'find-link/2 data keys))

(defun find-link (key data)
  "This is necesary since the proplists module requires 2-tuples only.

  This function assumes that the data desired (the href for the link) is in the
  second element of the three-tuple."
  (let ((`(#(href ,link)) (element 2 (lists:keyfind key 1 data))))
    link))

(defun map (content-func data)
  (lxml:map #'ident/1 content-func data))

(defun map (attr-func content-func data)
  (lxml:map #'ident/1 attr-func content-func data))

(defun map
  ((tag-func attr-func content-func `#(,tag ,attrs ,content))
    (tuple (funcall tag-func tag)
           (lists:map attr-func attrs)
           (lxml:map tag-func attr-func content-func content)))
  ((tag-func attr-func content-func `(,head . ,tail))
    (cons (lxml:map tag-func attr-func content-func head)
          (lxml:map tag-func attr-func content-func tail)))
  ((_ _ content-func x)
   (funcall content-func x)))

(defun ident (x)
  "The identity function."
  x)

;;; Supporting private functions

(defun parse-body (body options)
  (if (=:= (proplists:get_value 'result-type options) 'raw)
    (parse-body-raw body)
    (parse-body-to-atoms body)))

(defun parse-body-raw (body)
  (erlsom:simple_form body))

(defun parse-body-shaped
  ((`#(ok #(,tag ,attributes ,content) ,tail))
   `(#(tag ,tag)
     #(attr ,attributes)
     #(content #(,tag ,attributes ,content))
     #(tail ,tail))))

(defun parse-body-to-atoms (xml)
  (->> xml
       (parse-body-raw)
       (parse-body-shaped)
       (convert-keys)))

(defun convert-keys (data)
  "Convert property list keys to atoms."
  (lxml:map #'list_to_atom/1 #'key->atom/1 #'lxml:ident/1 data))

(defun key->atom
  ((`#(,key ,val)) (when (is_list key))
   `#(,(list_to_atom key) ,val))
  ((x) x))
