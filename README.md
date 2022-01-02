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

## Usage

0. Credential management
  a. Generate a Github Personal Access Token
  b. Make sure you are authenticated against the AWS Terraform provider
1. Adapt the configuration of the created Terraform resources
2. Create the Infrastructure and configure the Github Secrets
3. Add a `schedule` directive in the `./.github/workflows/backup.yml` Workflow

### Credential management

[gh-pat]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

You can create a PAT by following the documentation at
[creating a personal access token][gh-pat].

Then, export it in your environment by running:
```console
$ export GITHUB_TOKEN=ghp_xxxxxxxxxx
```

_See [Github Provider Authentication][gh-tf] for more information_
[gh-tf]: https://registry.terraform.io/providers/integrations/github/latest/docs#authentication

As for the AWS Terraform provider, please refer to the corresponding
documentation: [hashicorp/aws][aws-tf].

[aws-tf]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication

### Adapt the resources

You **must** edit the following in the `./terraform/main.tf` file:
- `module.bucket.bucket`: the name of the S3 Bucket (unique)
- `module.backup_user.{namespace,stage,name}`: the identifier of the IAM User
- `module.secrets.repository`: the name of your Github Repository

### Create the Terraform resources

Then, you can run the following commands in the `terraform` directory:
```console
$ terraform init
$ terraform apply
```

This will create:
- The AWS S3 Bucket bootstrapped using the `terraform-aws-s3-bucket` module
- An IAM User with API capabilities to authenticate the `pass-backup:archive` workflow
- The Github Actions Secret to set the S3 bucket identifiers and API keys

### Schedule the backups

In the `./.github/workflows/backup.yml` Workflow, add the following lines:
```yaml
on:
  workflow_dispatch:
  # add the lines below
  schedule:
    - cron: '30 5,17 * * *'
```

See [Schedule Trigger for Workflows][gh-schedule] for more information on the syntax

[gh-schedule]: https://docs.github.com/en/actions/learn-github-actions/events-that-trigger-workflows#scheduled-events

### Trying out the backup mechanism

You can confirm that your configuration is working as expected by
trigger the `pass-backup:archvie` Worfklow using `workflow_dispatch`.

See [Manual events - workflow_dispatch][gh-dispatch] for more informations.

[gh-dispatch]: https://docs.github.com/en/actions/learn-github-actions/events-that-trigger-workflows#manual-events
