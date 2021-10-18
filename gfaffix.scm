(define-module (gfaffix)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages rust))

(define-public gfaffix
  (package
    (name "gfaffix")
    (version "0.1.2.2")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/marschall-lab/GFAffix")
               (commit version)))
        (file-name (git-file-name name version))
        (sha256
         (base32 "1sh244yyhkaxbd635qjyig0wyxc57h8r1pwvs1vgdvlniw6h2cxy"))
        (modules '((guix build utils)))
        (snippet
         '(begin
            (substitute* "Cargo.toml"
              (("^handlegraph.*") "handlegraph = \"0.7\"\n"))))))
    (build-system cargo-build-system)
    (arguments
     `(#:rust ,(if (> (string->number (version-major+minor (package-version rust-1.49)))
                      (string->number (version-major+minor (package-version rust))))
                 rust-1.49
                 rust)
       #:cargo-inputs
       (("rust-clap" ,rust-clap-3)
        ("rust-rustc-hash" ,rust-rustc-hash-1)
        ("rust-regex" ,rust-regex-1)
        ("rust-handlegraph" ,rust-handlegraph-0.7)
        ("rust-gfa" ,rust-gfa-0.10)
        ("rust-quick-csv", rust-quick-csv-0.1)
        ("rust-log" ,rust-log-0.4)
        ("rust-env-logger" ,rust-env-logger-0.7))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'adjust-dependency-version
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((handlebar-version ,(package-version rust-handlegraph-0.7)))
               (substitute* "Cargo.toml"
                 (("\"0.7\"")
                  (string-append "{ version = \"" handlebar-version "\" }")))
               #t))))))
    (home-page "https://github.com/marschall-lab/GFAffix")
    (synopsis "Identify walk-preserving shared affixes in variation graphs")
    (description
     "GFAffix identifies walk-preserving shared affixes in variation graphs and
collapses them into a non-redundant graph structure.")
    (license license:expat)))

(define-public rust-handlegraph-0.7
  (package
    (inherit rust-handlegraph-0.3)
    (name "rust-handlegraph")
    (version "0.7.0-alpha.9")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "handlegraph" version))
        (file-name
         (string-append name "-" version ".tar.gz"))
        (sha256
         (base32
          "1frlcdwhycjvizb0gfb0v36vxjdi0jxagl2l2v6dzdjxpaawv9rs"))))
    (arguments
     `(#:rust ,(if (> (string->number (version-major+minor (package-version rust-1.47)))
                      (string->number (version-major+minor (package-version rust))))
                 rust-1.47
                 rust)
       #:cargo-inputs
       (("rust-anyhow" ,rust-anyhow-1)
        ("rust-boomphf" ,rust-boomphf-0.5)
        ("rust-bstr" ,rust-bstr-0.2)
        ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
        ("rust-fnv" ,rust-fnv-1)
        ("rust-gfa" ,rust-gfa-0.10)
        ("rust-log" ,rust-log-0.4)
        ("rust-rayon" ,rust-rayon-1)
        ("rust-succinct" ,rust-succinct-0.5))
       #:cargo-development-inputs
       (("rust-quickcheck" ,rust-quickcheck-0.9)
        ("rust-rand" ,rust-rand-0.7))))))
