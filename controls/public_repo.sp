locals {
  public_repo_best_practices_common_tags = merge(local.github_sherlock_common_tags, {
    service = "GitHub/Repository"
  })
}

benchmark "public_repo_best_practices" {
  title       = "Public Repository Best Practices"
  description = "Best practices for your public repositories."
  children = [
    control.public_repo_issues_enabled,
    control.public_repo_delete_branch_on_merge_enabled,
    control.public_repo_license_added,
    control.public_repo_code_of_conduct_added,
    control.public_repo_contributing_added,
    control.public_repo_readme_added,
    control.public_repo_pull_request_template_added,
    control.public_repo_description_set,
    control.public_repo_website_set,
    control.public_repo_topics_set,
    control.public_repo_default_branch_blocks_force_push,
    control.public_repo_default_branch_blocks_deletion,
    control.public_repo_default_branch_protections_apply_to_admins,
    control.public_repo_default_branch_requires_pull_request_reviews
  ]

  tags = merge(local.public_repo_best_practices_common_tags, {
    type = "Benchmark"
  })
}

control "public_repo_issues_enabled" {
  title       = "Issues should be enabled in each public repository"
  description = "Issues are essential to keep track of tasks, enhancements, and bugs."
  tags        = local.public_repo_best_practices_common_tags
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
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_delete_branch_on_merge_enabled" {
  title       = "Branches should automatically be deleted after merging in each public repository"
  description = "Automatically delete branches after merging to maintain only your active branches."
  tags        = local.public_repo_best_practices_common_tags
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
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_license_added" {
  title       = "License should be added in each public repository"
  description = "Licensing a public repository makes it easier for others to use and contribute."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when license_info is not null then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' license is ' || case when (license_info is not null) then (license_info ->> 'spdx_id') else 'not added' end || '.' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_code_of_conduct_added" {
  title       = "Code of conduct should be added in each public repository"
  description = "Adding a code of conduct defines standards for how your community engages in an inclusive environment."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when code_of_conduct is not null then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' code of conduct is ' || case when (code_of_conduct is not null) then (code_of_conduct ->> 'name') else 'not added' end || '.' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}


control "public_repo_contributing_added" {
  title       = "Contributing guidelines should be added in each public repository"
  description = "Adding a contributing guideline defines standards for how the community should contribute to the project."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.url as resource,
      case
        when p.contributing is not null then 'ok'
        else 'alarm'
      end as status,
      r.name_with_owner || case when (p.contributing is not null) then ' has ' else ' has no ' end || 'contributing guidelines.' as reason,
      r.name_with_owner
    from
      github_my_repository as r
      left join github_community_profile as p on r.name_with_owner = p.repository_full_name
    where
      visibility = 'PUBLIC' and r.is_fork = ${local.include_forks}
  EOT
}

control "public_repo_readme_added" {
  title       = "README should be added in each public repository"
  description = "Adding a README provides important information to help inform the community about the project."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.url as resource,
      case
        when p.readme is not null then 'ok'
        else 'alarm'
      end as status,
      r.name_with_owner || case when (p.readme is not null) then ' has a ' else ' has no ' end || 'README.' as reason,
      r.name_with_owner
    from
      github_my_repository as r
      left join github_community_profile as p on r.name_with_owner = p.repository_full_name
    where
      visibility = 'PUBLIC' and r.is_fork = ${local.include_forks}
  EOT
}

control "public_repo_pull_request_template_added" {
  title       = "Pull request template should be added in each public repository"
  description = "Adding a pull request template provides a consistent format for contributors' pull requests."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when pull_request_templates <> '[]' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || case when (pull_request_templates <> '[]') then ' has a ' else ' has no ' end || 'pull request template.' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_description_set" {
  title       = "Description should be set in each public repository"
  description = "Descriptions should be set to provide the community awareness of what is contained in the public repo."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when description <> '' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' description is ' || case when (description <> '') then description else 'not set' end || '.' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_website_set" {
  title       = "Website URL should be set in each public repository"
  description = "Website URL should be set to provide the community awareness of where they can go for more information about the project."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when homepage_url <> '' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' homepage is ' || case when (homepage_url <> '') then homepage_url else 'not set' end || '.' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_topics_set" {
  title       = "Topics should be set in each public repository"
  description = "Topics should be set to help others find and contribute to the project."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when repository_topics_total_count > 0 then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' has ' || repository_topics_total_count || ' topic(s).' as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_default_branch_blocks_force_push" {
  title       = "Default branch should block force push in each public repository"
  description = "Force pushing modifies commit history and should be avoided on the default branch."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when (default_branch_ref -> 'branch_protection_rule') is null then 'info'
        when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_force_pushes') = 'false' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' default branch ' || (default_branch_ref ->> 'name') ||
        case
          when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_force_pushes') = 'false' then ' prevents force push.'
          when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_force_pushes') = 'true' then ' allows force push.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected, or you have insufficient permissions to see branch protection rules.'
        end as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_default_branch_blocks_deletion" {
  title       = "Default branch should block deletion in each public repository"
  description = "The default branch is important and definitely shouldn't be deleted."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when (default_branch_ref -> 'branch_protection_rule') is null then 'info'
        when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_deletions') = 'false' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' default branch ' || (default_branch_ref ->> 'name') ||
        case
          when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_deletions') = 'false' then ' prevents deletion.'
          when (default_branch_ref -> 'branch_protection_rule' ->> 'allows_deletions') = 'true' then ' allows deletion.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected, or you have insufficient permissions to see branch protection rules.'
        end as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_default_branch_protections_apply_to_admins" {
  title       = "Default branch protections should apply to administrators in each public repository"
  description = "Administrators should have the same restrictions as other users for the default branch."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when (default_branch_ref -> 'branch_protection_rule') is null then 'info'
        when (default_branch_ref -> 'branch_protection_rule' ->> 'is_admin_enforced') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' default branch ' || (default_branch_ref ->> 'name') ||
        case
          when (default_branch_ref -> 'branch_protection_rule' ->> 'is_admin_enforced') = 'true' then ' protections apply to admins.'
          when (default_branch_ref -> 'branch_protection_rule' ->> 'is_admin_enforced') = 'false' then ' protections do not apply to admins.'
          -- If not false or true, then null, which means no branch protection rule exists
          else ' is not protected, or you have insufficient permissions to see branch protection rules.'
        end as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}

control "public_repo_default_branch_requires_pull_request_reviews" {
  title       = "Default branch requires pull request reviews before merging in each public repository"
  description = "Pull request reviews help improve quality of commits into the default branch."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when (default_branch_ref -> 'branch_protection_rule') is null then 'info'
        when (default_branch_ref -> 'branch_protection_rule' ->> 'requires_approving_reviews') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name_with_owner || ' default branch ' || (default_branch_ref ->> 'name') || 
        case 
          when (default_branch_ref -> 'branch_protection_rule') is null then ' is not protected, or you have insufficient permissions to see branch protection rules.'
          when (default_branch_ref -> 'branch_protection_rule' ->> 'requires_approving_reviews') = 'true' then ' requires pull request reviews.' 
          else ' does not require pull request reviews.' 
        end as reason,
      name_with_owner
    from
      github_my_repository
    where
      visibility = 'PUBLIC' and is_fork = ${local.include_forks}
  EOT
}
