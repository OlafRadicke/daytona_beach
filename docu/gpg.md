GNUPG
=====



| Operation                         | Command                    |
|-----------------------------------|----------------------------|
| Kill gpg-agent                    | `gpgconf --kill gpg-agent` |
| List                              | `gpg -k`                   |
| list secret keys                  | `gpg -K`                   |
| decrypt data (default)            | `gpg -d`                   |
| generate a new key pair           | `gpg --generate-key`       |
| full featured key pair generation | `gpg --full-generate-key`  |
| export keys                       | `gpg --export`             |
| import/merge keys                 | `gpg --import`             |