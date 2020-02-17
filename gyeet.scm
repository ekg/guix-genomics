(define-module (gyeet)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression))

(define-public gyeet
  (let ((version "0.0.0")
        (commit "ad52f439d55b671dd8e9a783fe6da9118348f0c9")
        (package-revision "1"))
    (package
     (name "gyeet")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/gyeet.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1035lax7kamhp7mwh50rws7xfhwpb9j49w37y9s9wqqyq47j8nj6"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         (delete 'check))
        #:make-flags (list "CC=gcc")))
     (native-inputs
      `(("cmake" ,cmake)
        ("glibc" ,glibc)
        ("gcc" ,gcc-9)
        ("zlib" ,zlib)))
     (synopsis "gyeet sequence to graph hacked mapper")
     (description
"gyeet maps sequences to a graph using a linearization trick. Locally,
if the graph is partially ordered, then standard alignment with Myers'
bit-parallel model will result in an approximately correct alignment.
By scoring in graph space, we avoid additional bias from using a linear
model.")
     (home-page "https://github.com/ekg/freebayes")
     (license license:expat))))

