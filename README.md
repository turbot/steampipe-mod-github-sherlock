# :warning: DEPRECATED

The GitHub Sherlock Mod has been deprecated and all the existing controls are migrated to GitHub Insight Mod. Please use the [GitHub Insights Mod](https://hub.steampipe.io/mods/turbot/github_insights) instead.

---

# GitHub Sherlock Mod for Steampipe

Interrogate your GitHub resources with the help of the World's greatest
detectives: Steampipe + Sherlock. GitHub Sherlock allows you to perform
deep analysis of your GitHub organization and repo configuration and test
them against operations & security best practices.

Run checks in a dashboard:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-github-sherlock/main/docs/github_sherlock_organization_dashboard.png)

Or in a terminal:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-github-sherlock/main/docs/github_sherlock_console_output.png)

## Current Sherlock Checks:
* [GitHub Organizations best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.org_best_practices)
* [Private Repo best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.private_repo_best_practices)
* [Public Repo best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.public_repo_best_practices)
* [Issue best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.issue_best_practices)

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
window at http://localhost:9194. From here, you can run benchmarks by
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

- **[Join #steampipe on Slack →](https://turbot.com/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-github-sherlock/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [GitHub Sherlock Mod](https://github.com/turbot/steampipe-mod-github-sherlock/labels/help%20wanted)
