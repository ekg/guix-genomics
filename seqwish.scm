(define-module (seqwish)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages datastructures)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages python)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression))

(define-public sdsl-lite-git
  (let ((commit "c32874cb2d8524119f25f3b501526fe692df29f4"))
   (package
    (name "sdsl-lite-git")
    (version (string-append "2.1.2-pre-" (string-take commit 7)))
    (source (origin
               (method git-fetch)
                (uri (git-reference
                 (url "https://github.com/simongog/sdsl-lite.git") 
                 (commit commit))) 
                 (file-name (string-append name "-" version "-checkout"))
                 (sha256
                  (base32
                    "1p53cgrgkp72s0mx262pxz90mf04vy4c1189xlx146qh8fznywg4"))
                (modules '((guix build utils)))
                (snippet
                 '(begin
                  (delete-file-recursively "external") #t))
                (patches (list
                   (search-patch "sdsl-lite-git.patch")))))
    (build-system cmake-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (add-after 'install 'install-static-library
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (copy-file "lib/libsdsl_static.a"
                          (string-append out "/lib/libsdsl.a")))
             #t)))))
    (inputs
     `(("doxygen" ,doxygen)
       ("graphviz" ,graphviz)))
    (native-inputs                                                                                         
     `(("libdivsufsort" ,libdivsufsort)))
    (home-page "https://github.com/simongog/sdsl-lite")
    (synopsis "Succinct data structure library")
    (description "The Succinct Data Structure Library (SDSL) is a powerful and
flexible C++11 library implementing succinct data structures.  In total, the
library contains the highlights of 40 research publications.  Succinct data
structures can represent an object (such as a bitvector or a tree) in space       
close to the information-theoretic lower bound of the object while supporting     
operations of the original object efficiently.  The theoretical time              
complexity of an operation performed on the classical data structure and the      
equivalent succinct data structure are (most of the time) identical.")            
    (license license:gpl3+))))

(define-public seqwish
  (let ((version "0.6.0")
        (commit "3680d31cc5548f4dc877863c9d0e7d77493b1d67")
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
                "1g3k0bbdfnbap2xw27js2yc2xqs96vxarmmg2hv0zx62hfjkz7lx"))
              (patches (list
                 (search-patch "seqwish.patch")))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         (delete 'check))))
     (inputs
      `(("sdsl-lite-git" ,sdsl-lite-git)))
     (native-inputs
      `(("gcc" ,gcc)
        ("cmake" ,cmake)
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
