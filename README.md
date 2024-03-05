# GitHub Sherlock Mod for Powerpipe

> [!IMPORTANT]
> Steampipe mods are [migrating to Powerpipe format](https://powerpipe.io) to gain new features. This mod currently works with both Steampipe and Powerpipe, but will only support Powerpipe from v1.x onward.

Interrogate your GitHub resources with the help of the World's greatest
detectives: Powerpipe + Sherlock. GitHub Sherlock allows you to perform
deep analysis of your GitHub organization and repo configuration and test
them against operations & security best practices.

Run checks in a dashboard:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-github-sherlock/add-new-checks/docs/github_sherlock_organization_dashboard.png)

Or in a terminal:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-github-sherlock/add-new-checks/docs/github_sherlock_console_output.png)

## Documentation

- **[Benchmarks and controls →](https://hub-powerpipe-io-git-development-turbot.vercel.app/mods/turbot/github_sherlock/controls)**
- **[Named queries →](https://hub-powerpipe-io-git-development-turbot.vercel.app/mods/turbot/github_sherlock/queries)**

## Current Sherlock Checks:
* [GitHub Organizations best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.org_best_practices)
* [Private Repo best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.private_repo_best_practices)
* [Public Repo best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.public_repo_best_practices)
* [Issue best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.issue_best_practices)

## Getting started

### Installation

Install Powerpipe (https://powerpipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/powerpipe
```

This mod also requires [Steampipe](https://steampipe.io) with the [Github plugin](https://hub.steampipe.io/plugins/turbot/github) as the data source. Install Steampipe (https://steampipe.io/downloads), or use Brew:

```sh
brew install turbot/tap/steampipe
steampipe plugin install github
```

This mod uses the credentials configured in the [GitHub plugin credential](https://hub.steampipe.io/plugins/turbot/github#credentials).

Finally, install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/steampipe-mod-github-sherlock
```

### Browsing Dashboards

Start Steampipe as the data source:

```sh
steampipe service start
```

Start the dashboard server:

```sh
powerpipe server
```

Browse and view your dashboards at **http://localhost:9033**.

### Running Checks in Your Terminal

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `powerpipe benchmark` command:

List available benchmarks:

```sh
powerpipe benchmark list
```

Run a benchmark:

```sh
powerpipe benchmark run github_sherlock.benchmark.org_best_practices
```

Different output formats are also available, for more information please see
[Output Formats](https://powerpipe.io/docs/reference/cli/benchmark#output-formats).

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Steampipe](https://steampipe.io) and [Powerpipe](https://powerpipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [GitHub Sherlock Mod](https://github.com/turbot/steampipe-mod-github-sherlock/labels/help%20wanted)