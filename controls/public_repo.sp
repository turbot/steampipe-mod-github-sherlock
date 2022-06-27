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
      visibility = 'public' and fork = ${local.include_forks}
  EOT
}

control "public_repo_delete_branch_on_merge_enabled" {
  title       = "Branches should automatically be deleted after merging in each public repository"
  description = "Automatically delete branches after merging to maintain only your active branches."
  tags        = local.public_repo_best_practices_common_tags
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
      visibility = 'public' and fork = ${local.include_forks}
  EOT
}

control "public_repo_license_added" {
  title       = "License should be added in each public repository"
  description = "Licensing a public repository makes it easier for others to use and contribute."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      html_url as resource,
      case
        when license_spdx_id is not null then 'ok'
        else 'alarm'
      end as status,
      full_name || ' license is ' || case when(license_spdx_id is not null) then license_name else 'not added' end || '.' as reason,
      full_name
    from
      github_my_repository
    where
      visibility = 'public' and fork = ${local.include_forks}
  EOT
}

control "public_repo_code_of_conduct_added" {
  title       = "Code of conduct should be added in each public repository"
  description = "Adding a code of conduct defines standards for how your community engages in an inclusive environment."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      html_url as resource,
      case
        when code_of_conduct_key not like 'none' then 'ok'
        else 'alarm'
      end as status,
      full_name || ' code of conduct is ' || case when(code_of_conduct_key is not null) then code_of_conduct_name else 'not added' end || '.' as reason,
      full_name
    from
      github_my_repository
    where
      visibility = 'public' and fork = ${local.include_forks}
  EOT
}

control "public_repo_contributing_added" {
  title       = "Contributing guidelines should be added in each public repository"
  description = "Adding a contributing guideline defines standards for how the community should contribute to the project."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when p.contributing is not null then 'ok'
        else 'alarm'
      end as status,
      r.full_name || case when(p.contributing is not null) then ' has ' else ' has no ' end || 'contributing guidelines.' as reason,
      r.full_name
    from
      github_my_repository as r
      left join github_community_profile as p on r.full_name = p.repository_full_name
    where
      visibility = 'public' and r.fork = ${local.include_forks}
  EOT
}

control "public_repo_readme_added" {
  title       = "README should be added in each public repository"
  description = "Adding a README provides important information to help inform the community about the project."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when p.readme is not null then 'ok'
        else 'alarm'
      end as status,
      r.full_name || case when(p.readme is not null) then ' has a ' else ' has no ' end || 'README.' as reason,
      r.full_name
    from
      github_my_repository as r
      left join github_community_profile as p on r.full_name = p.repository_full_name
    where
      visibility = 'public' and r.fork = ${local.include_forks}
  EOT
}

control "public_repo_pull_request_template_added" {
  title       = "Pull request template should be added in each public repository"
  description = "Adding a pull request template provides a consistent format for contributors' pull requests."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when p.pull_request_template is not null then 'ok'
        else 'alarm'
      end as status,
      r.full_name || case when(p.pull_request_template is not null) then ' has a ' else ' has no ' end || 'pull request template.' as reason,
      r.full_name
    from
      github_my_repository as r
      left join github_community_profile as p on r.full_name = p.repository_full_name
    where
      visibility = 'public' and r.fork = ${local.include_forks}
  EOT
}

control "public_repo_description_set" {
  title       = "Description should be set in each public repository"
  description = "Descriptions should be set to provide the community awareness of what is contained in the public repo."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      html_url as resource,
      case
        when description <> '' then 'ok'
        else 'alarm'
      end as status,
      full_name || ' description is ' || case when(description <> '') then description else 'not set' end || '.' as reason,
      full_name
    from
      github_my_repository
    where
      visibility = 'public' and fork = ${local.include_forks}
  EOT
}

control "public_repo_website_set" {
  title       = "Website URL should be set in each public repository"
  description = "Website URL should be set to provide the community awareness of where they can go for more information about the project."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      html_url as resource,
      case
        when homepage is not null then 'ok'
        else 'alarm'
      end as status,
      full_name || ' homepage is ' || case when (homepage is not null) then homepage else 'not set' end || '.' as reason,
      full_name
    from
      github_my_repository
    where
      visibility = 'public' and fork = ${local.include_forks}
  EOT
}

control "public_repo_topics_set" {
  title       = "Topics should be set in each public repository"
  description = "Topics should be set to help others find and contribute to the project."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      html_url as resource,
      case
        when topics <> '[]' then 'ok'
        else 'alarm'
      end as status,
      full_name || ' has ' || jsonb_array_length(topics) || ' topic(s).' as reason,
      full_name
    from
      github_my_repository
    where
      visibility = 'public' and fork = ${local.include_forks}
  EOT
}

control "public_repo_default_branch_blocks_force_push" {
  title       = "Default branch should block force push in each public repository"
  description = "Force pushing modifies commit history and should be avoided on the default branch."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when b.allow_force_pushes_enabled = 'false' then 'ok'
        else 'alarm'
      end as status,
      r.full_name || ' default branch ' || r.default_branch ||
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
      visibility = 'public' and r.fork = ${local.include_forks}
  EOT
}

control "public_repo_default_branch_blocks_deletion" {
  title       = "Default branch should block deletion in each public repository"
  description = "The default branch is important and definitely shouldn't be deleted."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when b.allow_deletions_enabled = 'false' then 'ok'
        else 'alarm'
      end as status,
      r.full_name || ' default branch ' || r.default_branch ||
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
      visibility = 'public' and r.fork = ${local.include_forks}
  EOT
}

control "public_repo_default_branch_protections_apply_to_admins" {
  title       = "Default branch protections should apply to administrators in each public repository"
  description = "Administrators should have the same restrictions as other users for the default branch."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when b.enforce_admins_enabled = 'true' then 'ok'
        else 'alarm'
      end as status,
      r.full_name || ' default branch ' || r.default_branch ||
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
      visibility = 'public' and r.fork = ${local.include_forks}
  EOT
}

control "public_repo_default_branch_requires_pull_request_reviews" {
  title       = "Default branch requires pull request reviews before merging in each public repository"
  description = "Pull request reviews help improve quality of commits into the default branch."
  tags        = local.public_repo_best_practices_common_tags
  sql = <<-EOT
    select
      r.full_name as resource,
      case
        when b.required_pull_request_reviews is not null then 'ok'
        else 'alarm'
      end as status,
      r.full_name || ' default branch ' || r.default_branch || case when(b.required_pull_request_reviews is not null) then ' requires ' else ' does not require ' end || 'pull request reviews.' as reason,
      r.full_name
    from
      github_my_repository as r
      left join github_branch_protection as b on r.full_name = b.repository_full_name and r.default_branch = b.name
    where
      visibility = 'public' and r.fork = ${local.include_forks}
  EOT
}
