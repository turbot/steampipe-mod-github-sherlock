---
repository: "https://github.com/turbot/steampipe-mod-github-sherlock"
---

# GitHub Sherlock Mod

Interrogate your GitHub resources with the help of the world's greatest detectives: Steampipe + Sherlock.

<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-github-sherlock/main/docs/github_sherlock_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-github-sherlock/main/docs/github_sherlock_organization_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-github-sherlock/main/docs/github_sherlock_console_output.png" width="50%" type="thumbnail"/>

## References

[GitHub](https://github.com/) is a provider of Internet hosting for software development and version control using Git.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/github_sherlock/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/github_sherlock/queries)**

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the GitHub plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install github
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-github-sherlock.git
cd steampipe-mod-github-sherlock
```

### Usage

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at https://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command:

Run all benchmarks:

```sh
steampipe check all
```

Run a single benchmark:

```sh
steampipe check benchmark.org_best_practices
```

Run a specific control:

```sh
steampipe check control.org_two_factor_required
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).


### Credentials

This mod uses the credentials configured in the [Steampipe GitHub plugin](https://hub.steampipe.io/plugins/turbot/github).

### Configuration

No extra configuration is required.

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-github-sherlock/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [GitHub Compliance Mod](https://github.com/turbot/steampipe-mod-github-sherlock/labels/help%20wanted)