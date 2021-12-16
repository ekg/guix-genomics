(define-module (seqwish)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages compression))

(define-public seqwish
  (let ((version "0.7.3")
        (commit "51ee55079ccb89402fdb50999268f3382678b083")
        (package-revision "1"))
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
                "0cpq1zgpfsnss0dcq3kg1rjl80nhr8rdpvsl60h0pcxb8wfqq412"))))
     (build-system cmake-build-system)
     (arguments
      `(#:tests? #f
        #:phases
        (modify-phases
         %standard-phases
         ;; This stashes our build version in the executable
         (add-after 'unpack 'set-version
           (lambda _
             (mkdir "include")
             (with-output-to-file "include/seqwish_git_version.hpp"
               (lambda ()
                 (format #t "#define SEQWISH_GIT_VERSION \"~a\"~%" version)))
             #t))
         (delete 'check))
        ))
     (inputs
      `(("gcc" ,gcc-11)
        ("jemalloc" ,jemalloc)
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
