# Pass Backup

[![pass-backup:ci](https://github.com/tbobm/pass-backup/actions/workflows/terraform.yml/badge.svg)](https://github.com/tbobm/pass-backup/actions/workflows/terraform.yml) [![pass-backup:archive](https://github.com/tbobm/pass-backup/actions/workflows/backup.yml/badge.svg)](https://github.com/tbobm/pass-backup/actions/workflows/backup.yml)

Perform regular backups of a pass git repository.

See: [_pass, the standard unix password manager_][pass-unix]

[pass-unix]: https://www.passwordstore.org/

_`pass` is a password management solution with GPG encryption and
a native git support_

_note: I've been using this tool for a couple of years now, I highly
recommend giving it a try_

## Goal

This repository aims to offer a simple backup mechanism of git repositories
used to version control passwords managed using `pass`, the standard unix
password manager. ([site][pass-unix])

The [pass-backup:archive][archive] Workflow is used to schedule a Job
that will create a tarball archive of the `passwords` directory and
upload it to AWS S3.

[archive]: https://github.com/tbobm/pass-backup/actions/workflows/backup.yml

It leverages 2 services:
- AWS S3: store the password archive tarball
- Github Actions: generate the tarball and copy it to AWS S3

## Features

- Regular backups to an S3 bucket
- GPG-encrypted passwords using `pass`
- Easy to implement: terraform manifests are available in [`./terraform/`](./terraform/)

### next steps

- [ ] KMS encryption
- [ ] Different S3 backends

## Example

```console
$ export PASSWORD_STORE_DIR=$PWD/passwords/
$ pass git init
```
