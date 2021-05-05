(define-module (pggb)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (wfmash)
  #:use-module (seqwish)
  #:use-module (smoothxg)
  #:use-module (odgi)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages time))

(define-public pggb
  (let ((version "0.1.0")
        (commit "9209280731a543d3847390ef5614319328a0c56b")
        (package-revision "6"))
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
                "16in4f86vlqi7nazddz57wms8y6ynhpb3vyn408q0z39nag4c3nc"))))
     (build-system copy-build-system)
     (arguments
      '(#:install-plan
        '(("pggb" "bin/"))))
     (inputs
      `(("wfmash" ,wfmash)
        ("seqwish" ,seqwish)
        ("smoothxg" ,smoothxg)
        ("odgi" ,odgi)
        ("time" ,time)
        ("bc" ,bc)
        ("bash" ,bash)
        ("pigz" ,pigz)))
     (synopsis "the pangenome graph builder")
     (description "This pangenome graph construction pipeline renders
a collection of sequences into a pangenome graph (in the variation
graph model).  Its goal is to build a graph that is locally directed
and acyclic while preserving large-scale variation.  Maintaining local
linearity is important for the interpretation, visualization, and
reuse of pangenome variation graphs.")
     (home-page "https://github.com/pangenome/pggb")
     (license license:expat))))
