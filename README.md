# guix genomics packages

This repo contains guix package definitions (aka guile build scripts) for bioinformatics tools that I author and deploy.

## usage

To install packages from these definitions, **specify the path of this repository** as your `GUIX_PACKAGE_PATH`.
For instance, to install `wfmash` from within this repository directory:

```bash
GUIX_PACKAGE_PATH=. guix package -i wfmash
```

If the guix-genomics repository directory were in your home directory, you might do this:

```bash
GUIX_PACKAGE_PATH=~/guix-genomics guix package -i wfmash
```

## updating

To build and update a package, first change the commit id and/or version in its .scm file and then run:

```
tool=tool_name; GUIX_PACKAGE_PATH=. guix build $tool && GUIX_PACKAGE_PATH=. guix package -i $tool && git commit -a -m 'update '$tool && git push origin master
``
