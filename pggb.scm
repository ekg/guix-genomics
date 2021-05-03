(define-module (pggb)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages))

(define-public pggb
  (let ((version "0.1.0")
        (commit "4eb6ba9aae1062594a234581ba81dedafdedc521")
        (package-revision "1"))
    (package
     (name "pggb")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/pangenome/pggb.git")
                    (commit commit)
                    (recursive? #f)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0izip35a0xd8r018p1smfxpiwlhpva1aqqfi23xwck854xgibw4n"))))
     (build-system copy-build-system)
     (arguments
      '(#:install-plan
        '(("pggb" "bin/"))))
     (inputs
      `(("wfmash" ,wfmash)
        ("seqwish" ,seqwish)
        ("smoothxg" ,smoothxg)
        ("odgi" ,odgi)
        ("pigz" ,pigz)))
     (synopsis "the pangenome graph builder"
     (description "This pangenome graph construction pipeline renders
a collection of sequences into a pangenome graph (in the variation
graph model).  Its goal is to build a graph that is locally directed
and acyclic while preserving large-scale variation.  Maintaining local
linearity is important for the interpretation, visualization, and
reuse of pangenome variation graphs.")
     (home-page "https://github.com/pangenome/pggb")
     (license license:expat))))
