benchmark "issue_best_practices" {
  title = "Issue Best Practices"
  description = "Best practices for your issues."
  children = [
    control.issue_has_assignee,
    control.issue_has_labels,
    control.issue_older_30_days
  ]
}

control "issue_has_assignee" {
  title = "Issues should have at least 1 user assigned"
  description = "Issues should have at least 1 assignee so it's clear who is responsible for it."
  sql = <<-EOT
    select
      i.html_url as resource,
      case
        when jsonb_array_length(i.assignee_logins) < 1 then 'alarm'
        when jsonb_array_length(i.assignee_logins) = 1 then 'ok'
        -- More than 1 assignee could be ok, but let users know there's more than 1
        else 'info'
      end as status,
      '#' || i.issue_number || ' ' || i.title || ' has ' || jsonb_array_length(i.assignee_logins) || ' assignee(s).' as reason,
      i.repository_full_name
    from
      github_my_repository as r
      left join github_issue as i on r.full_name = i.repository_full_name
    where
      r.fork = ${local.include_forks} and i.state = 'open'
  EOT
}

control "issue_has_labels" {
  title = "Issues should have labels applied"
  description = "Labels help organize issues and provide users with more context."
  sql = <<-EOT
    select
      i.html_url as resource,
      case
        when i.labels <> '[]' then 'ok'
        else 'alarm'
      end as status,
      '#' || i.issue_number || ' ' || i.title || ' has ' || jsonb_array_length(i.labels) || ' label(s).' as reason,
      i.repository_full_name
    from
      github_my_repository as r
      left join github_issue as i on r.full_name = i.repository_full_name
    where
      r.fork = ${local.include_forks} and i.state = 'open'
  EOT
}

control "issue_older_30_days" {
  title = "Issues should not be open longer than 30 days"
  description = "Issues should be resolved or closed in a timely manner."
  sql = <<-EOT
    select
      i.html_url as resource,
      case
        when i.created_at <= (current_date - interval '30' day) then 'alarm'
        else 'ok'
      end as status,
      '#' || i.issue_number || ' ' || i.title || ' created ' || to_char(i.created_at , 'DD-Mon-YYYY') ||
        ' (' || extract(day from current_timestamp - i.created_at) || ' days).' as reason,
      i.repository_full_name
    from
      github_my_repository as r
      left join github_issue as i on r.full_name = i.repository_full_name
    where
      r.fork = ${local.include_forks} and i.state = 'open'
  EOT
}
