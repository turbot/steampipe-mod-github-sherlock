locals {
  include_forks = "false"
}

benchmark "private_repo_best_practices" {
  title = "Private Repository Best Practices"
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
}

control "private_repo_issues_enabled" {
  title = "Issues should be enabled in each private repository"
  description = "Issues are essential to keep track of tasks, enhancements, and bugs."
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
  title = "Branches should automatically be deleted after merging in each private repository"
  description = "Automatically delete branches after merging to maintain only your active branches."
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
  title = "No outside collaborators should have access in each private repository"
  description = "Outside collaborators should not have access to private repository content."
  sql = <<-EOT
    select
      html_url as resource,
      case
        when outside_collaborator_logins = '[]' then 'ok'
        else 'alarm'
      end as status,
      full_name || ' has ' || jsonb_array_length(outside_collaborator_logins) || ' outside collaborator(s).' as reason,
      full_name
    from
      github_my_repository
    where
      visibility = 'private' and fork = ${local.include_forks}
  EOT
}

control "private_repo_default_branch_blocks_force_push" {
  title = "Default branch should block force push in each private repository"
  description = "Force pushing modifies commit history and should be avoided on the default branch."
  sql = <<-EOT
    with my_repository AS (
    select
      full_name
    from
      github_my_repository where visibility = 'private' and fork = ${local.include_forks}
    order by full_name
),
 branch_protection as (
     select
      repository_full_name,
      name as branch_name,
      allow_force_pushes_enabled
    from
      github_branch_protection 
    where repository_full_name = (select full_name from github_my_repository where visibility = 'private' and fork = ${local.include_forks})
    order by repository_full_name
 )
select
      full_name as resource,
      case
        when allow_force_pushes_enabled = 'false' then 'ok'
        else 'alarm'
      end as status,
      full_name || ' default branch ' || branch_name || 
      case
          when allow_force_pushes_enabled = 'false' then ' prevents force push.'
          when allow_force_pushes_enabled = 'true' then ' allows force push.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected.'
        end as reason,
      full_name
    from
       my_repository r left join branch_protection p on r. full_name = p.repository_full_name
    where branch_name in ('main', 'master') 
  EOT
}

control "private_repo_default_branch_blocks_deletion" {
  title = "Default branch should block deletion in each private repository"
  description = "The default branch is important and definitely shouldn't be deleted."
  sql = <<-EOT
    with my_repository AS (
    select
      full_name
    from
      github_my_repository where visibility = 'private' and fork = ${local.include_forks}
    order by full_name
),
 branch_protection as (
     select
      repository_full_name,
      name as branch_name,
      allow_deletions_enabled
    from
      github_branch_protection 
    where repository_full_name = (select full_name from github_my_repository where visibility = 'private' and fork = ${local.include_forks})
    order by repository_full_name
 )
select
      full_name as resource,
      case
        when allow_deletions_enabled = 'false' then 'ok'
        else 'alarm'
      end as status,
      full_name || ' default branch ' || branch_name ||
        case
          when allow_deletions_enabled = 'false' then ' prevents deletion.'
          when allow_deletions_enabled = 'true' then ' allows deletion.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected.'
        end as reason,
      full_name
    from
       my_repository r left join branch_protection p on r. full_name = p.repository_full_name
    where branch_name in ('main', 'master')  
  EOT
}

control "private_repo_default_branch_protections_apply_to_admins" {
  title = "Default branch protections should apply to administrators in each private repository"
  description = "Administrators should have the same restrictions as other users for the default branch."
  sql = <<-EOT
    with my_repository AS (
    select
      full_name
    from
      github_my_repository where visibility = 'private' and fork = ${local.include_forks}
    order by full_name
),
 branch_protection as (
     select
      repository_full_name,
      name as branch_name,
      enforce_admins_enabled
    from
      github_branch_protection 
    where repository_full_name = (select full_name from github_my_repository where visibility = 'private' and fork = ${local.include_forks})
    order by repository_full_name
 )
select
      full_name as resource,
      case
        when enforce_admins_enabled = 'true' then 'ok'
        else 'alarm'
      end as status,
      full_name || ' default branch ' || branch_name ||
        case
          when enforce_admins_enabled = 'true' then ' protections apply to admins.'
          when enforce_admins_enabled = 'false' then ' protections do not apply to admins.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected.'
        end as reason,
      full_name
    from
       my_repository r left join branch_protection p on r. full_name = p.repository_full_name
    where branch_name in ('main', 'master')  
  EOT
}

control "private_repo_default_branch_requires_pull_request_reviews" {
  title = "Default branch requires pull request reviews before merging in each private repository"
  description = "Pull request reviews help improve quality of commits into the default branch."
  sql = <<-EOT
    with my_repository AS (
    select
      full_name
    from
      github_my_repository where visibility = 'private' and fork = ${local.include_forks}
    order by full_name
),
 branch_protection as (
     select
      repository_full_name,
      name as branch_name,
      required_pull_request_reviews
    from
      github_branch_protection 
    where repository_full_name = (select full_name from github_my_repository where visibility = 'private' and fork = ${local.include_forks})
    order by repository_full_name
 )
select
      full_name as resource,
      case
        when required_pull_request_reviews is not null then 'ok'
        else 'alarm'
      end as status,
      full_name || ' default branch ' || branch_name || case when(required_pull_request_reviews is not null) then ' requires ' else ' does not require ' end || 'pull request reviews.' as reason,
      full_name
    from
       my_repository r left join branch_protection p on r. full_name = p.repository_full_name
    where branch_name in ('main', 'master')  
  EOT
}
