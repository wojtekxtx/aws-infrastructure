## Usage

1. Get valid AWS credentials. Preferably with [aws-vault](https://github.com/99designs/aws-vault).
2. [Install](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) session manager plugin
3. Edit your `~/.ssh/config` with:
    ```
    host i-* mi-*
       ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
    ```
4. Get SSH private key.

Now you can login to bastion host with `ssh admin@i-0b2e41134b64540d4`.
