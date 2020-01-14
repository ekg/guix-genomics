(define-module (gimbricate)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages python)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression))

(define-public gimbricate
  (let ((version "v0.1.0")
        (commit "849a7fb1360e7b1e09d361d65f3f9f1316f33875")
        (package-revision "1"))
    (package
     (name "gimbricate")
     (version (string-append version "+" (string-take commit 7) "-" package-revision))
     (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ekg/gimbricate.git")
                    (commit commit)
                    (recursive? #t)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1skmncd9aan7ffv7fxzzs93dhgjj1hmn8z994m5sqrwsafzd20rm"))))
     (build-system cmake-build-system)
     (arguments
      `(#:phases
        (modify-phases
         %standard-phases
         (delete 'check))))
     (native-inputs
      `(("gcc" ,gcc-9)
        ("cmake" ,cmake)
        ("zlib" ,zlib)))
     (synopsis "Corrects the overlaps in DNA sequence graphs by realigning sequence ends.")
     (description
"Almost no overlap-based assembly methods produce correct GFAv1
output. Invariably, some overlaps are incorrectly defined. (The major exception
to this are De Bruijn assemblers, which have fixed length overlaps that are
correct by definition.) In some methods (like shasta), the overlaps are
systematically slightly wrong, due to their derivation from run length encoded
sequences. It can help to correct these, because it lets us \"bluntify\" the
graph. This produces a graph in which each base in the graph exists on only one
node, which is a desirable property for variation graph and other pangenomic
reference models")
     (home-page "https://github.com/ekg/freebayes")
     (license license:expat))))
