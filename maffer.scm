(define-module (maffer)
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

(define-public maffer
  (let ((version "0.1.1")
        (commit "69efa1fdf78ba47d70f1bce58e1f23cb64dd1554")
        (package-revision "1"))
    (package
     (name "maffer")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/pangenome/maffer.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "12kbw0mvrjj1xfhffvj1myjbb7c9p166fjqdzry5livvr0d7rywx"))))
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
     (synopsis "extract MSAs from genome variation graphs")
     (description
"This tool projects between pangenomic variation graphs stored in
GFAv1, which can be used to encode whole genome alignments, and the
multiple alignment format MAF, which represents only the linearizable
components of such an alignment graph. Its goal is to allow tools like
seqwish, which efficiently construct whole genome alignment graphs
from collections of sequences and pairwise alignments between them, to
be applied to comparative genomics problems.")
     (home-page "https://github.com/pangenome/maffer")
     (license license:expat))))

