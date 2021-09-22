---
repository: "https://github.com/turbot/steampipe-mod-github-sherlock"
---

# GitHub Sherlock Mod

Interrogate your GitHub resources with the help of the world's greatest detectives: Steampipe + Sherlock.

## References

[GitHub](https://github.com/) is a provider of Internet hosting for software development and version control using Git.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.


## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/github_sherlock/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/github_sherlock/queries)**

## Get started

Install the GitHub plugin with [Steampipe](https://steampipe.io):
```shell
steampipe plugin install github
```

Clone:
```sh
git clone https://github.com/turbot/steampipe-mod-github-sherlock.git
cd steampipe-mod-github-sherlock
```

Run all benchmarks:
```shell
steampipe check all
```

Run a benchmark:
```shell
steampipe check benchmark.private_repo_best_practices
```

Run a specific control:
```shell
steampipe check control.public_repo_code_of_conduct_added
```

### Credentials

This mod uses the credentials configured in the [Steampipe GitHub plugin](https://hub.steampipe.io/plugins/turbot/github).

### Configuration

No extra configuration is required.

## Get involved

* Contribute: [GitHub Repo](https://github.com/turbot/steampipe-mod-github-sherlock)
* Community: [Slack Channel](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)
