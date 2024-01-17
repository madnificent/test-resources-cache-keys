(in-package :mu-cl-resources)

(setf *include-count-in-paginated-responses* t)
(setf *supply-cache-headers-p* t)
(setf sparql:*experimental-no-application-graph-for-sudo-select-queries* t)
(setf *cache-model-properties-p* t)


;; we want a relationship two steps further and inheritance

(define-resource thing ()
  :class (s-prefix "schema:Thing")
  :properties `((:name :string ,(s-prefix "schema:name")))
  :resource-base (s-url "http://resources.services.semantic.works/tests/things/")
  :on-path "things")

(define-resource address (thing)
  :class (s-prefix "schema:PostalAddress")
  :properties `((:street-address :string ,(s-prefix "schema:streetAddress"))
                (:postal-code :string ,(s-prefix "schema:postalCode"))
                (:locality :string ,(s-prefix "schema:addressLocality")))
  :has-many `((person :via ,(s-prefix "schema:address")
                      :inverse t
                      :as "persons"))
  :resource-base (s-url "http://resources.services.semantic.works/tests/addresses/")
  :on-path "addresses")

(define-resource agent (thing)
  :class (s-prefix "foaf:Agent")
  :resource-base (s-url "http://resources.services.semantic.works/tests/agents/")
  :on-path "agents")

(define-resource person (agent)
  :class (s-prefix "schema:Person")
  :properties `((:given-name :string ,(s-prefix "schema:givenName"))
                (:family-name :string ,(s-prefix "schema:familyName")))
  :has-many `((creative-work :via ,(s-prefix "schema:author")
                             :inverse t
                             :as "creative-works"))
  :has-one `((address :via ,(s-prefix "schema:address")
                      :as "address"))
  :resource-base (s-url "http://resources.services.semantic.works/tests/people/")
  :on-path "people")

(define-resource creative-work (thing)
  :class (s-prefix "schema:CreativeWork")
  :properties `((:title :string ,(s-prefix "dct:title")))
  :has-many `((comment :via ,(s-prefix "schema:comment")
                       :as "comments"))
  :has-one `((person :via ,(s-prefix "schema:author")
                     :as "author"))
  :resource-base (s-url "http://resources.services.semantic.works/tests/creative-works/")
  :on-path "creative-works")

(define-resource book (creative-work)
  :class (s-prefix "schema:Book")
  :properties `((:isbn :string ,(s-prefix "schema:isbn")))
  :resource-base (s-url "http://resources.services.semantic.works/tests/books/")
  :on-path "books")

(define-resource coloring-book (book)
  :class (s-prefix "ext:ColoringBook")
  :resource-base (s-url "http://resources.services.semantic.works/tests/coloring-books/")
  :has-one `((person :via ,(s-prefix "ext:artist")
                     :as "author"))
  :on-path "coloring-books")

(define-resource comment (creative-work)
  :class (s-prefix "schema:Comment")
  :properties `((:upvote-count :number ,(s-prefix "schema:upvoteCount"))
                (:downvote-count :number ,(s-prefix "schema:downvoteCount")))
  :has-one `((creative-work :via ,(s-prefix "schema:comment")
                            :inverse t
                            :as "creative-work"))
  :resource-base (s-url "http://resources.services.semantic.works/tests/comments/")
  :on-path "comments")

;; reading in the domain.json
(read-domain-file "domain.json")
