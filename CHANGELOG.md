## v0.5 [2021-11-24]

_Bug fixes_

- Organization best practice controls now skips with proper reason for repository requires elevated role to query ([18](https://github.com/turbot/steampipe-mod-github-sherlock/pull/18))
- `private_repo_no_outside_collaborators` control now skips with proper reason for repository requires elevated role to query ([20](https://github.com/turbot/steampipe-mod-github-sherlock/pull/20))
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
