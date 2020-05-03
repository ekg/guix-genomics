(define-module (mmseqs2)
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
  #:use-module (gnu packages vim)
  #:use-module (gnu packages compression))

(define-public mmseqs2
  (let ((version "11")
        (commit "290668474611312a94a868bf041b38c8618f5ef6")
        (package-revision "1"))
    (package
     (name "mmseqs2")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/soedinglab/MMseqs2.git")
                    (commit commit)
                    (recursive? #f)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "17yw20k585ywdr8ii3n7gmsgrclwl8fq9a374s5h16b4jfjscy3w"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         (delete 'check))
        #:configure-flags '("-DCMAKE_BUILD_TYPE=Release")))
     (native-inputs
      `(("cmake" ,cmake)
        ("glibc" ,glibc)
        ("gcc" ,gcc-9)
        ("zlib" ,zlib)
        ("xxd" ,xxd)))
     (synopsis "ultra fast and sensitive search and clustering suite")
     (description
"MMseqs2 (Many-against-Many sequence searching) is a software suite to
search and cluster huge protein and nucleotide sequence sets. MMseqs2
is open source GPL-licensed software implemented in C++ for Linux,
MacOS, and (as beta version, via cygwin) Windows. The software is
designed to run on multiple cores and servers and exhibits very good
scalability. MMseqs2 can run 10000 times faster than BLAST. At 100
times its speed it achieves almost the same sensitivity. It can
perform profile searches with the same sensitivity as PSI-BLAST at
over 400 times its speed.")
     (home-page "https://mmseqs.com/")
     (license license:gpl3+))))

