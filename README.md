# guix genomics packages

This repo contains guix package definitions (aka guile build scripts) for bioinformatics tools that I author and deploy.

## usage

To install packages from these definitions, specify the `GUIX_PACKAGE_PATH`.
For instance, to install edyeet:

```bash
GUIX_PACKAGE_PATH=. guix package -i edyeet
```

## updating

To build and update a package, first change the commit id and/or version in its .scm file and then run:

```
tool=tool_name; GUIX_PACKAGE_PATH=. guix build $tool && GUIX_PACKAGE_PATH=. guix package -i $tool && git commit -a -m 'update '$tool && git push origin master
``
