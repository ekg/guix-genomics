(define-module (freebayes)
               #:use-module (guix packages)
               #:use-module (guix git-download)
               #:use-module (guix build-system gnu)
               #:use-module (guix licenses)
               #:use-module (gnu packages base)
               #:use-module (gnu packages gcc)
               #:use-module (gnu packages cmake)
               #:use-module (gnu packages python)
               #:use-module (gnu packages wget)
               #:use-module (gnu packages bash)
               #:use-module (gnu packages compression))

(define-public freebayes
  (let ((version "v1.3.2")
        (commit "f4fbc319d155cc8c108cf97bb26c2129f17a41ac")
        (package-revision "0"))
    (package
     (name "freebayes")
     (version (string-append (git-version version "+" commit) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/freebayes.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0rpw94dsw627cwy43lzih2ifrh60ld24ps3n9k79pf2wl5cgb5j7"))))
     (build-system gnu-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         ;; Setting the SHELL environment variable is required by SeqLib's configure script
         (add-after 'unpack 'set-shell
                    (lambda _
                      (setenv "CONFIG_SHELL" (which "sh"))
                      #t))
         ;; This stashes our build version in the executable
         (replace 'configure
                  (lambda _
                    (substitute* "src/version_release.txt" (("v1.0.0") ,version))
                    #t))
         (delete 'check)
         (replace 'install
                  (lambda* (#:key outputs #:allow-other-keys)
                           (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                             (install-file "bin/freebayes" bin)
                             (install-file "bin/bamleftalign" bin)))))
        #:make-flags (list "CC=gcc")))
     (native-inputs
      `(("wget" ,wget)
        ("cmake" ,cmake)
        ("zlib" ,zlib)))
     (synopsis "freebayes haplotype-based genetic variant caller")
     (description
      "freebayes is a Bayesian genetic variant detector designed to find small polymorphisms, specifically SNPs (single-nucleotide polymorphisms), indels (insertions and deletions), MNPs (multi-nucleotide polymorphisms), and complex events (composite insertion and substitution events) smaller than the length of a short-read sequencing alignment.")
     (home-page "https://github.com/ekg/freebayes")
     (license expat))))

freebayes
