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
      url as resource,
      case
        when has_issues_enabled then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' issues are ' || case when(has_issues_enabled)::bool then 'enabled' else 'disabled' end || '.' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PRIVATE' and is_fork = ${local.include_forks}
  EOT
}

control "private_repo_delete_branch_on_merge_enabled" {
  title       = "Branches should automatically be deleted after merging in each private repository"
  description = "Automatically delete branches after merging to maintain only your active branches."
  tags        = local.private_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when delete_branch_on_merge then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' delete branch on merge is ' || case when(delete_branch_on_merge)::bool then 'enabled' else 'disabled' end || '.' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PRIVATE' and is_fork = ${local.include_forks}
  EOT
}

control "private_repo_no_outside_collaborators" {
  title       = "No outside collaborators should have access in each private repository"
  description = "Outside collaborators should not have access to private repository content."
  sql = <<-EOT
    select
      url as resource,
      case
        when outside_collaborator_total_count = 0 then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' has ' || outside_collaborator_total_count || ' outside collaborator(s).' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PRIVATE' and is_fork = ${local.include_forks}
  EOT
}

control "private_repo_default_branch_blocks_force_push" {
  title       = "Default branch should block force push in each private repository"
  description = "Force pushing modifies commit history and should be avoided on the default branch."
  tags        = local.private_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_force_pushes') = 'false' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' default branch ' || (default_branch_ref ->> 'name') ||
        case
          when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_force_pushes') = 'false' then ' prevents force push.'
          when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_force_pushes') = 'true' then ' allows force push.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected.'
        end as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PRIVATE' and is_fork = ${local.include_forks}
  EOT
}

control "private_repo_default_branch_blocks_deletion" {
  title       = "Default branch should block deletion in each private repository"
  description = "The default branch is important and definitely shouldn't be deleted."
  sql = <<-EOT
    select
      url as resource,
      case
        when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_deletions') = 'false' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' default branch ' || (default_branch_ref ->> 'name') ||
        case
          when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_deletions') = 'false' then ' prevents deletion.'
          when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_deletions') = 'true' then ' allows deletion.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected.'
        end as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PRIVATE' and is_fork = ${local.include_forks}
  EOT
}

control "private_repo_default_branch_protections_apply_to_admins" {
  title       = "Default branch protections should apply to administrators in each private repository"
  description = "Administrators should have the same restrictions as other users for the default branch."
  tags        = local.private_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when (default_branch_ref -> 'branch_protection_rule' ->> 'is_admin_enforced') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' default branch ' || (default_branch_ref ->> 'name') ||
        case
          when (default_branch_ref -> 'branch_protection_rule' ->> 'is_admin_enforced') = 'true' then ' protections apply to admins.'
          when (default_branch_ref -> 'branch_protection_rule' ->> 'is_admin_enforced') = 'false' then ' protections do not apply to admins.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected.'
        end as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PRIVATE' and is_fork = ${local.include_forks}
  EOT
}

control "private_repo_default_branch_requires_pull_request_reviews" {
  title       = "Default branch requires pull request reviews before merging in each private repository"
  description = "Pull request reviews help improve quality of commits into the default branch."
  tags        = local.private_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when (default_branch_ref -> 'branch_protection_rule' ->> 'requires_approving_reviews') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' default branch ' || (default_branch_ref ->> 'name') || 
        case when (default_branch_ref -> 'branch_protection_rule' ->> 'requires_approving_reviews') = 'true' then ' requires ' else ' does not require ' end || 'pull request reviews.' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PRIVATE' and is_fork = ${local.include_forks}
  EOT
}
