# lorvet-conf

## Pre-Installation

* Copy puppet/hieradata/local.yaml.sample into puppet/hieradata/local.yaml
* Create a [personal access token](https://github.com/settings/tokens) for cloning the repositories
* Edit puppet/hieradata/local.yaml and enter the personal token generated into git::github_oauth

* Install vendor puppet modules using librarian-puppet:
```
./scripts/upgrade-puppet.sh
./scripts/librarian-install.sh
```

```
vagrant provision
```
