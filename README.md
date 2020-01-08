# guix genomics packages

This repo contains guix package definitions (aka guile build scripts) for bioinformatics tools that I author and deploy.

## usage

To install packages from these definitions, specify the `GUIX_PACKAGE_PATH`.
For instance, to install shasta:

```bash
GUIX_PACKAGE_PATH=. guix package -i shasta
```
