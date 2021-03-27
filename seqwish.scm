(define-module (seqwish)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages python)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression))

(define-public seqwish
  (let ((version "0.7.0")
        (commit "9eb09823b6e7f4c72dac7b2a08faa3d80c2e3d79")
        (package-revision "4"))
    (package
     (name "seqwish")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/seqwish.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "06hihjg096fkbaxmn74r6vgxyfwws4vvrjs9n5jvk8n5xsk1lsmj"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         (delete 'check))))
     (native-inputs
      `(("cmake" ,cmake)
        ("zlib" ,zlib)))
     (synopsis "variation graph inducer")
     (description
"seqwish implements a lossless conversion from pairwise alignments between
sequences to a variation graph encoding the sequences and their alignments.  As
input we typically take all-versus-all alignments, but the exact structure of
the alignment set may be defined in an application specific way.  This algorithm
uses a series of disk-backed sorts and passes over the alignment and sequence
inputs to allow the graph to be constructed from very large inputs that are
commonly encountered when working with large numbers of noisy input sequences.")
     (home-page "https://github.com/ekg/freebayes")
     (license license:expat))))
