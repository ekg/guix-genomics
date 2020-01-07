(define-module (odgi)
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

(define-public odgi
  (let ((version "v0.1.0")
        (commit "2c5f8c04dfa4c447a10f27e96227148cb9355264")
        (package-revision "1"))
    (package
     (name "odgi")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/vgteam/odgi.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1drrcfyy4mny56vfrlrq62q2mcrbz85af7p3phzxhalavjspm433"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         ;; Setting the SHELL environment variable is required by SeqLib's configure script
         ;(add-after 'unpack 'set-shell
         ;           (lambda _
         ;             (setenv "CONFIG_SHELL" (which "sh"))
         ;             #t))
         ;(delete 'configure)
         (delete 'check)
         (replace 'install
                  (lambda* (#:key outputs #:allow-other-keys)
                           (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                             (install-file "bin/odgi" bin)))))
        #:make-flags (list "CC=gcc")))
     (native-inputs
      `(("cmake" ,cmake)
        ("glibc" ,glibc)
        ("python" ,python)
        ("pybind11" ,pybind11)
        ("zlib" ,zlib)))
     (synopsis "odgi optimized dynamic sequence graph implementation")
     (description
      "odgi provides an efficient, succinct dynamic DNA sequence graph model, as well as a host of algorithms that allow the use of such graphs in bioinformatic analyses.")
     (home-page "https://github.com/ekg/freebayes")
     (license license:expat))))

odgi
