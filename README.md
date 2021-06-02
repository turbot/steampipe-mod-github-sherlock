# GitHub Sherlock

Interrogate your GitHub resources with the help of the World's greatest
detectives: Steampipe + Sherlock. GitHub Sherlock allows you to perform 
deep analysis of your GitHub organization and repo configuration and test 
them against operations & security best practices.

![image](https://github.com/turbot/steampipe-mod-github-sherlock/blob/main/docs/github-sherlock-output.png?raw=true)

## Current Sherlock Checks
- [GitHub Organizations best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.org_best_practices)
- [Private Repo best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.private_repo_best_practices)
- [Public Repo best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.public_repo_best_practices)
- [Issue best practices](https://hub.steampipe.io/mods/turbot/github_sherlock/controls/benchmark.issue_best_practices)


## Quick start

1) Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```shell
brew tap turbot/tap
brew install steampipe

steampipe -v 
steampipe version 0.5.1
```

2) Install the GitHub plugin:
```shell
steampipe plugin install github
```

3) Configure your GitHub creds: [Instructions](https://hub.steampipe.io/plugins/turbot/github#credentials)

`vi ~/.steampipe/config/github.spc`
```hcl
connection "github" {
  plugin = "github"
  token  = "111222333444555666777888999aaabbbcccddde"
}
```

4) Clone this repo and step into the directory:
```sh
git clone git@github.com:turbot/steampipe-mod-github-sherlock
cd steampipe-mod-github-sherlock
```

5) Run the checks:
```shell
steampipe check all
```

You can also run a specific controls by name:
```shell
steampipe check control.public_repo_code_of_conduct_added
```

Use introspection to view the available controls:
```
steampipe query "select resource_name from steampipe_control;"
```

## Contributing

Have an idea for additional checks or best practices?
- **[Join our Slack community →](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)**
- **[Mod developer guide →](https://steampipe.io/docs/steampipe-mods/writing-mods.md)**

**Prerequisites**:
- [Steampipe installed](https://steampipe.io/downloads)
- Steampipe GitHub plugin installed (see above)

**Fork**:
Click on the GitHub Fork Widget. (Don't forget to :star: the repo!)

**Clone**:

1. Change the current working directory to the location where you want to put the cloned directory on your local filesystem.
2. Type the clone command below inserting your GitHub username instead of `YOUR-USERNAME`:

```sh
git clone git@github.com:YOUR-USERNAME/steampipe-mod-github-sherlock
cd steampipe-mod-github-sherlock
```

Thanks for getting involved! We would love to have you [join our Slack community](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g) and hang out with other Steampipe Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-aws-compliance/blob/main/LICENSE).

`help wanted` issues:
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [GitHub Sherlock Mod](https://github.com/turbot/steampipe-mod-github-sherlock/labels/help%20wanted)
