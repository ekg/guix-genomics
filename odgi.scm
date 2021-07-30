(define-module (odgi)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages jemalloc)
  #:use-module (gnu packages python))

(define-public odgi
  (let ((version "0.6.0")
        (commit "84de3765719ef5e7c513846c61dd886c30c5d010")
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
                "05wf694qjnckaq05hq9dlldxh25wvww4b1inhml6h1dh8pdb4k9l"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         ;; This stashes our build version in the executable
         (add-after 'unpack 'set-version
           (lambda _
             (mkdir "include")
             (with-output-to-file "include/odgi_git_version.hpp"
               (lambda ()
                 (format #t "#define ODGI_GIT_VERSION \"~a\"~%" version)))
             #t))
         (delete 'check))
        #:make-flags (list ,(string-append "CC=" (cc-for-target)))))
     (native-inputs
      `(("python" ,python)
        ("jemalloc" ,jemalloc)
        ("gcc" ,gcc-11)))
     (synopsis "odgi optimized dynamic sequence graph implementation")
     (description
"odgi provides an efficient, succinct dynamic DNA sequence graph model, as well
as a host of algorithms that allow the use of such graphs in bioinformatic
analyses.")
     (home-page "https://github.com/vgteam/odgi")
     (license license:expat))))

