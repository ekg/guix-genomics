(define-module (paf2dot)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages xdisorg))

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
                    (commit commit)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0zr5jv4wjy35bk97hrcvwvi94d4cnvh5mr5230nz56ni6dgz02ic"))))
     (build-system trivial-build-system)
     (arguments
      `(#:modules ((guix build utils))
        #:builder
        (begin
          (use-modules (guix build utils))
          (let* ((out (assoc-ref %outputs "out"))
                 (bin (string-append out "/bin"))
                 (doc (string-append out "/share/doc/" ,name "-" ,version))
                 (perl (string-append (assoc-ref %build-inputs "perl") "/bin")))
            (install-file (string-append (assoc-ref %build-inputs "source") "/paf2dot") bin)
            (install-file (string-append (assoc-ref %build-inputs "source") "/README.md") doc)
            (patch-shebang (string-append bin "/paf2dot") (list perl))
            (wrap-script (string-append out "/bin/paf2dot")
                         #:guile (string-append (assoc-ref %build-inputs "guile") "/bin/guile")
              `("PATH" ":" prefix (,(string-append (assoc-ref %build-inputs "gnuplot") "/bin")
                                   ,(string-append (assoc-ref %build-inputs "xclip") "/bin"))))
            #t))))
     (inputs
      `(("gnuplot" ,gnuplot)
        ("guile" ,guile-3.0)
        ("perl" ,perl)
        ("xclip" ,xclip)))
     (synopsis "visualize alignments in PAF format using gnuplot")
     (description "Use gnuplot to generate a dotplot from sequence
alignments in PAF format. Only the alignment / mapping start and end
are plotted.")
     (home-page "https://github.com/pangenome/paf2dot")
     (license license:expat))))
