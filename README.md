![image](https://hub.steampipe.io/images/mods/turbot/github-sherlock-social-graphic.png)

# Steampipe mod to analyze GitHub

Interrogate your GitHub resources with the help of the World's greatest
detectives: Steampipe + Sherlock. Steampipe's Sherlock mod for GitHub allows
you to perform deep analysis of your GitHub configuration and test all your
GitHub resources against operations & security best practices.

*Can you write SQL and HCL? [Fork this repo](#developing) as the basis for your own custom best practice checks!*

* **[Get started →](https://hub.steampipe.io/mods/turbot/github_sherlock)**
* Documentation: [Controls](https://hub.steampipe.io/mods/turbot/github_sherlock/controls)
* Community: [Slack Channel](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)
* Get involved: [Issues](https://github.com/turbot/steampipe-mod-github-sherlock/issues)

## Quick start

Install the GitHub plugin with [Steampipe](https://steampipe.io):
```shell
steampipe plugin install github
```

Clone:
```sh
git clone git@github.com:turbot/steampipe-mod-github-sherlock
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

## Developing

Have an idea but aren't sure how to get started?
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

**View controls and benchmarks**:
```
steampipe query "select resource_name from steampipe_control;"
```

```sql
steampipe query
> select
    resource_name
  from
    steampipe_benchmark
  order by
    resource_name;
```

## Contributing

Thanks for getting involved! We would love to have you [join our Slack community](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g) and hang out with other Steampipe Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-aws-compliance/blob/main/LICENSE).

`help wanted` issues:
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [GitHub Sherlock Mod](https://github.com/turbot/steampipe-mod-github-sherlock/labels/help%20wanted)
