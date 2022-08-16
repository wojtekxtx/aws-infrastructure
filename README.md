# Saleor Integrations AWS infrastructure

This repository contains terraform modules for AWS infrastructure for Saleor Integrations. Each module has it's README.md (if it needs any explanation)

Core assumptions:
* Every app must have a health check endpoint e.g. `/healthcheck/ping`.
* App is ran inside docker.
* Services are terminated on single ALB and one domain. Routing based on `Host` header.
* Store secrets in Parameter Store, using software like [Chamber](https://github.com/segmentio/chamber/wiki/Installation#linux-binaries)
* Tag docker images.

Best practicies:
* Use github CI with AWS role using [actions plugin](https://github.com/aws-actions/configure-aws-credentials). TF modules in this repo.
* To gain access into internal VPC resources, use bastion module from this repo.
* To speed up `terraform init`, add below line to `~/.terraformrc`
    ```
    plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"
    ```
