(define-module (paf2dot)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages))

(define-public paf2dot
  (let ((version "0.0.0")
        (commit "a0896418bcfd4b373337f60349ed48665967f974")
        (package-revision "1"))
    (package
     (name "paf2dot")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/pangenome/paf2dot.git")
                    (commit commit)
                    (recursive? #f)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1xfapi2cpxk1jk122jbgzasnxnb2l6x2ypaa2qbk66irlp318xv4"))))
     (build-system copy-build-system)
     (arguments
      '(#:install-plan
        '(("paf2dot" "bin/"))))
     (inputs
      `(("gnuplot" ,gnuplot)))
     (synopsis "visualize alignments in PAF format using gnuplot")
     (description "Use gnuplot to generate a dotplot from sequence
alignments in PAF format. Only the alignment / mapping start and end
are plotted.")
     (home-page "https://github.com/pangenome/paf2dot")
     (license license:expat))))
