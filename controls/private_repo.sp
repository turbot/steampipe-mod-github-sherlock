locals {
  include_forks = "false"
  private_repo_best_practices_common_tags = merge(local.github_sherlock_common_tags, {
    service = "GitHub/Repository"
  })
}

benchmark "private_repo_best_practices" {
  title       = "Private Repository Best Practices"
  description = "Best practices for your private repositories."
  children = [
    control.private_repo_issues_enabled,
    control.private_repo_delete_branch_on_merge_enabled,
    control.private_repo_no_outside_collaborators,
    control.private_repo_default_branch_blocks_force_push,
    control.private_repo_default_branch_blocks_deletion,
    control.private_repo_default_branch_protections_apply_to_admins,
    control.private_repo_default_branch_requires_pull_request_reviews
  ]

  tags = merge(local.private_repo_best_practices_common_tags, {
    type = "Benchmark"
  })
}

control "private_repo_issues_enabled" {
  title       = "Issues should be enabled in each private repository"
  description = "Issues are essential to keep track of tasks, enhancements, and bugs."
  tags        = local.private_repo_best_practices_common_tags
  sql = <<-EOT
    select
      html_url as resource,
      case
        when has_issues then 'ok'
        else 'alarm'
      end as status,
      full_name || ' issues are ' || case when(has_issues)::bool then 'enabled' else 'disabled' end || '.' as reason,
      full_name
    from
      github_my_repository
    where
      visibility = 'private' and fork = ${local.include_forks}
  EOT
}

control "private_repo_delete_branch_on_merge_enabled" {
  title       = "Branches should automatically be deleted after merging in each private repository"
  description = "Automatically delete branches after merging to maintain only your active branches."
  tags        = local.private_repo_best_practices_common_tags
  sql = <<-EOT
    select
      html_url as resource,
      case
        when delete_branch_on_merge then 'ok'
        else 'alarm'
      end as status,
      full_name || ' delete branch on merge is ' || case when(delete_branch_on_merge)::bool then 'enabled' else 'disabled' end || '.' as reason,
      full_name
    from
      github_my_repository
    where
      visibility = 'private' and fork = ${local.include_forks}
  EOT
}

control "private_repo_no_outside_collaborators" {
  title       = "No outside collaborators should have access in each private repository"
  description = "Outside collaborators should not have access to private repository content."
  sql = <<-EOT
    select
      html_url as resource,
      case
        when outside_collaborator_logins is null then 'skip'
        when outside_collaborator_logins = '[]' then 'ok'
        else 'alarm'
      end as status,
      case
      -- <outside_collaborator_logins> access requires elevated role access to repository
      -- https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-roles-for-an-organization
      when outside_collaborator_logins is null then 'User needs elevated right to query in ' || full_name || ' repo.'
      else full_name || ' has ' || jsonb_array_length(outside_collaborator_logins) || ' outside collaborator(s).'
      end as reason,
      full_name
    from
      github_my_repository
    where
      visibility = 'private' and fork = ${local.include_forks}
  EOT
}

control "private_repo_default_branch_blocks_force_push" {
  title       = "Default branch should block force push in each private repository"
  description = "Force pushing modifies commit history and should be avoided on the default branch."
  tags        = local.private_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when b.allow_force_pushes_enabled = 'false' then 'ok'
        else 'alarm'
      end as status,
      r.full_name || ' default branch ' || b.name ||
        case
          when b.allow_force_pushes_enabled = 'false' then ' prevents force push.'
          when b.allow_force_pushes_enabled = 'true' then ' allows force push.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected.'
        end as reason,
      r.full_name
    from
      github_my_repository as r
      left join github_branch_protection as b on r.full_name = b.repository_full_name and r.default_branch = b.name
    where
      visibility = 'private' and r.fork = ${local.include_forks}
  EOT
}

control "private_repo_default_branch_blocks_deletion" {
  title       = "Default branch should block deletion in each private repository"
  description = "The default branch is important and definitely shouldn't be deleted."
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when b.allow_deletions_enabled = 'false' then 'ok'
        else 'alarm'
      end as status,
      r.full_name || ' default branch ' || b.name ||
        case
          when b.allow_deletions_enabled = 'false' then ' prevents deletion.'
          when b.allow_deletions_enabled = 'true' then ' allows deletion.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected.'
        end as reason,
      r.full_name
    from
      github_my_repository as r
      left join github_branch_protection as b on r.full_name = b.repository_full_name and r.default_branch = b.name
    where
      visibility = 'private' and r.fork = ${local.include_forks}
  EOT
}

control "private_repo_default_branch_protections_apply_to_admins" {
  title       = "Default branch protections should apply to administrators in each private repository"
  description = "Administrators should have the same restrictions as other users for the default branch."
  tags        = local.private_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when b.enforce_admins_enabled = 'true' then 'ok'
        else 'alarm'
      end as status,
      r.full_name || ' default branch ' || b.name ||
        case
          when b.enforce_admins_enabled = 'true' then ' protections apply to admins.'
          when b.enforce_admins_enabled = 'false' then ' protections do not apply to admins.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected.'
        end as reason,
      r.full_name
    from
      github_my_repository as r
      left join github_branch_protection as b on r.full_name = b.repository_full_name and r.default_branch = b.name
    where
      visibility = 'private' and r.fork = ${local.include_forks}
  EOT
}

control "private_repo_default_branch_requires_pull_request_reviews" {
  title       = "Default branch requires pull request reviews before merging in each private repository"
  description = "Pull request reviews help improve quality of commits into the default branch."
  tags        = local.private_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when b.required_pull_request_reviews is not null then 'ok'
        else 'alarm'
      end as status,
      r.full_name || ' default branch ' || b.name || case when(b.required_pull_request_reviews is not null) then ' requires ' else ' does not require ' end || 'pull request reviews.' as reason,
      r.full_name
    from
      github_my_repository as r
      left join github_branch_protection as b on r.full_name = b.repository_full_name and r.default_branch = b.name
    where
      visibility = 'private' and r.fork = ${local.include_forks}
  EOT
}
