# Pass Backup

Perform regular backups of a pass git repository.

See: [_pass, the standard unix password manager_][pass]

[pass-unix]: https://www.passwordstore.org/

## Features

- Regular backups to an S3 bucket
- GPG-encrypted

### next steps

- [ ] KMS encryption

## Example

```console
$ export PASSWORD_STORE_DIR=$PWD/passwords/
$ pass git init
```
