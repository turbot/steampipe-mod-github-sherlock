locals {
  organization_best_practices_common_tags = merge(local.github_sherlock_common_tags, {
    service = "GitHub/Organization"
  })
}

benchmark "org_best_practices" {
  title = "Organization Best Practices"
  description = "Best practices for your organizations."
  children = [
    control.org_all_seats_used,
    control.org_two_factor_required,
    control.org_members_cannot_create_public_repos,
    control.org_members_cannot_create_pages,
    control.org_domain_verified,
    control.org_default_repo_permissions_limited,
    control.org_email_set,
    control.org_homepage_set,
    control.org_description_set,
    control.org_profile_pic_set,
  ]

  tags = merge(local.organization_best_practices_common_tags, {
    type = "Benchmark"
  })
}

control "org_all_seats_used" {
  title       = "All organization seats should be allocated"
  description = "Unused organization seats cost money and should be allocated or removed."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when plan_filled_seats >= plan_seats then 'ok'
        else 'alarm'
      end as status,
      login || ' uses ' || plan_filled_seats || ' out of ' || plan_seats || '.' as reason,
      login
    from
      github_my_organization
  EOT
}

control "org_two_factor_required" {
  title       = "Two-factor authentication should be required for users in an organization"
  description = "Two-factor authentication makes it harder for unauthorized actors to access repositories and organizations."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when two_factor_requirement_enabled is null then 'info'
        when two_factor_requirement_enabled then 'ok'
        else 'alarm'
      end as status,
      login ||
        case
          when two_factor_requirement_enabled is null then ' 2FA requirement unverifiable'
          when (two_factor_requirement_enabled)::bool then ' requires 2FA'
          else ' does not require 2FA'
        end || '.' as reason,
      login
    from
      github_my_organization
  EOT
}

control "org_domain_verified" {
  title       = "Domain should be verified in an organization"
  description = "Verifying your domain helps to confirm the organization's identity and send emails to users with verified emails."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when is_verified then 'ok'
        else 'alarm'
      end as status,
      coalesce(name, login) || ' domain is ' || case when (is_verified)::bool then 'verified' else 'not verified' end || '.' as reason,
      login
    from
      github_my_organization
  EOT
}

control "org_members_cannot_create_public_repos" {
  title       = "Organization members should not be able to create public repositories"
  description = "Accidentally creating a public repository can expose code and other assets."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when members_can_create_public_repos then 'alarm'
        else 'ok'
      end as status,
      login || ' users ' || case when (members_can_create_public_repos)::bool then 'can ' else 'cannot ' end || 'create public repositories.' as reason,
      login
    from
      github_my_organization
  EOT
}

control "org_members_cannot_create_pages" {
  title       = "Organization members should not be able to create pages"
  description = "Pages are public and may contain internal or sensitive information."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when members_can_create_pages then 'alarm'
        else 'ok'
      end as status,
      login || ' users ' || case when (members_can_create_pages)::bool then 'can ' else 'cannot ' end || 'create pages.' as reason,
      login
    from
      github_my_organization
  EOT
}

control "org_email_set" {
  title       = "Organization email should be set"
  description = "Setting an email provides useful contact information for users."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when email is null then 'alarm'
        when email = '' then 'alarm'
        else 'ok'
      end as status,
      coalesce(name, login) || ' email is ' || case when (email is null) then 'not set' when (email = '') then 'not set' else email end || '.' as reason,
      login
    from
      github_my_organization
  EOT
}

control "org_homepage_set" {
  title       = "Organization homepage should be set"
  description = "Setting a homepage helps users learn more about your organization."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when website_url is null then 'alarm'
        when website_url = '' then 'alarm'
        else 'ok'
      end as status,
      coalesce(name, login) || ' homepage is ' || case when (website_url is null) then 'not set' when (website_url = '') then 'not set' else website_url end || '.' as reason,
      login
    from
      github_my_organization
  EOT
}

control "org_default_repo_permissions_limited" {
  title       = "Organization default repository permissions should be limited"
  description = "Members of your organization should not have write or admin permissions by default in all repositories."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when default_repo_permission is null then 'skip'
        when default_repo_permission in ('write', 'admin') then 'alarm'
        else 'ok'
      end as status,
    case
      when default_repo_permission is null then 'User do not have required permission to query ' || login || '.'
      else login || ' default repository permissions are ' || default_repo_permission || '.'
    end as reason,
      login
    from
      github_my_organization
  EOT
}

control "org_description_set" {
  title       = "Organization description should be set"
  description = "Setting a description helps users learn more about your organization."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when description <> '' then 'ok'
        else 'alarm'
      end as status,
      coalesce(name, login) || ' description is ' || case when(description <> '') then description else 'not set' end || '.' as reason,
      login
    from
      github_my_organization
  EOT
}

control "org_profile_pic_set" {
  title       = "Organization profile picture should be set"
  description = "Setting a profile picture helps users recognize your brand."
  tags        = local.organization_best_practices_common_tags
  sql = <<-EOT
    select
      url as resource,
      case
        when avatar_url is not null then 'ok'
        else 'alarm'
      end as status,
      coalesce(name, login) || ' profile picture URL is ' || case when(avatar_url <> '') then avatar_url else 'not set' end || '.' as reason,
      login
    from
      github_my_organization
  EOT
}
