(define-module (pggb)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system trivial)
  #:use-module (wfmash)
  #:use-module (seqwish)
  #:use-module (smoothxg)
  #:use-module (odgi)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages time))

(define-public pggb
  (let ((version "0.1.0")
        (commit "930e9ba4bd4405ebe21b9160666afe3702e47737")
        (package-revision "7"))
    (package
     (name "pggb")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/pangenome/pggb.git")
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0jcrmir4yrqajwd8zh5pvndgr544l5gih84pv4cmxn790lp0n0mr"))))
     (build-system trivial-build-system)
     (arguments
      `(#:modules ((guix build utils))
        #:builder
        (begin
          (use-modules (guix build utils))
          (let* ((out (assoc-ref %outputs "out"))
                 (bin (string-append out "/bin"))
                 (doc (string-append out "/share/doc/" ,name "-" ,version))
                 (bash (string-append (assoc-ref %build-inputs "bash") "/bin")))
            (install-file (string-append (assoc-ref %build-inputs "source") "/pggb") bin)
            (install-file (string-append (assoc-ref %build-inputs "source") "/LICENSE") doc)
            (patch-shebang (string-append bin "/pggb") (list bash))
            (wrap-script (string-append out "/bin/pggb")
                         #:guile (string-append (assoc-ref %build-inputs "guile") "/bin/guile")
              `("PATH" ":" prefix (,(string-append (assoc-ref %build-inputs "bc") "/bin")
                                   ,(string-append (assoc-ref %build-inputs "odgi") "/bin")
                                   ,(string-append (assoc-ref %build-inputs "pigz") "/bin")
                                   ,(string-append (assoc-ref %build-inputs "seqwish") "/bin")
                                   ,(string-append (assoc-ref %build-inputs "smoothxg") "/bin")
                                   ,(string-append (assoc-ref %build-inputs "time") "/bin")
                                   ,(string-append (assoc-ref %build-inputs "wfmash") "/bin"))))
            #t))))
     (inputs
      `(("bash" ,bash-minimal)
        ("bc" ,bc)
        ("guile" ,guile-3.0)
        ("odgi" ,odgi)
        ("pigz" ,pigz)
        ("seqwish" ,seqwish)
        ("smoothxg" ,smoothxg)
        ("time" ,time)
        ("wfmash" ,wfmash)))
     (synopsis "Pangenome graph builder")
     (description "This pangenome graph construction pipeline renders
a collection of sequences into a pangenome graph (in the variation
graph model).  Its goal is to build a graph that is locally directed
and acyclic while preserving large-scale variation.  Maintaining local
linearity is important for the interpretation, visualization, and
reuse of pangenome variation graphs.")
     (home-page "https://github.com/pangenome/pggb")
     (license license:expat))))
