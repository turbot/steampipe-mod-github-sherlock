## v0.11 [2023-07-07]

_Enhancements_

- Updated the `private_repo_no_outside_collaborators` control to align with the breaking changes in the [GitHub plugin](https://github.com/turbot/steampipe-plugin-github/blob/main/CHANGELOG.md#v0290-2023-07-07). ([#45](https://github.com/turbot/steampipe-mod-github-sherlock/pull/45))

_Dependencies_

- GitHub plugin `v0.29.0` or higher is now required. ([#45](https://github.com/turbot/steampipe-mod-github-sherlock/pull/45))

## v0.10 [2023-06-21]

_What's new?_

- All queries have been updated to work with GitHub plugin v0.28.0, which includes a large number of breaking changes as 25+ tables have been updated to use GitHub's GraphQL API. For more information, please see the plugin's [v0.28.0 release notes](https://github.com/turbot/steampipe-plugin-github/blob/main/CHANGELOG.md#v0280-2023-06-21).

_Dependencies_

- GitHub plugin `v0.28.0` or higher is now required. ([#42](https://github.com/turbot/steampipe-mod-github-sherlock/pull/42))

## v0.9 [2022-06-28]

_Enhancements_

- Updated the following controls to check protections for all default branches, not just `main` or `master`: ([#36](https://github.com/turbot/steampipe-mod-github-sherlock/pull/36))
  - `private_repo_default_branch_blocks_deletion`
  - `private_repo_default_branch_blocks_force_push`
  - `private_repo_default_branch_protections_apply_to_admins`
  - `private_repo_default_branch_requires_pull_request_reviews`
  - `public_repo_default_branch_blocks_deletion`
  - `public_repo_default_branch_blocks_force_push`
  - `public_repo_default_branch_protections_apply_to_admins`
  - `public_repo_default_branch_requires_pull_request_reviews`
- Thanks to [@francois2metz](https://github.com/francois2metz) for the enhancements above!

## v0.8 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README with new dashboard screenshots and latest format. ([#34](https://github.com/turbot/steampipe-mod-github-sherlock/pull/34))

## v0.7 [2022-04-29]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#31](https://github.com/turbot/steampipe-mod-github-sherlock/pull/31))

## v0.6 [2022-01-05]

_Enhancements_

- Updated the inline queries of `private_repo_default_branch_blocks_force_push`, `private_repo_default_branch_blocks_deletion`, `private_repo_default_branch_protections_apply_to_admins`, `private_repo_default_branch_requires_pull_request_reviews`, `public_repo_default_branch_blocks_force_push`, `public_repo_default_branch_blocks_deletion`, `public_repo_default_branch_protections_apply_to_admins` and `public_repo_default_branch_requires_pull_request_reviews` controls to use the `in` operator ([#26](https://github.com/turbot/steampipe-mod-github-sherlock/pull/26))

## v0.5 [2021-11-24]

_Bug fixes_

- Organization best practice controls now skips with proper reason for repository requires elevated role to query ([18](https://github.com/turbot/steampipe-mod-github-sherlock/pull/18))
- The control `private_repo_no_outside_collaborators` now skips with proper reason for repository requires elevated role to query ([20](https://github.com/turbot/steampipe-mod-github-sherlock/pull/20))
- Updated queries for the below controls ([14](https://github.com/turbot/steampipe-mod-github-sherlock/pull/14))
  - `private_repo_default_branch_blocks_deletion`
  - `private_repo_default_branch_protections_apply_to_admins`
  - `private_repo_default_branch_requires_pull_request_reviews`
  - `private_repo_default_branch_blocks_force_push`
  - `public_repo_default_branch_blocks_deletion`
  - `public_repo_default_branch_protections_apply_to_admins`
  - `public_repo_default_branch_requires_pull_request_reviews`
  - `public_repo_default_branch_blocks_force_push`

## v0.4 [2021-09-09]

_Bug fixes_

- Duplicate local variables have now been removed across all the control files

## v0.3 [2021-05-28]

_Bug fixes_

- Fixed: Indentation is now correct in all SQL queries

## v0.2 [2021-05-28]

_Enhancements_

- Updated brand color to better represent the mod
