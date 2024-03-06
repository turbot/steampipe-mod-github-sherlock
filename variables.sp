// Benchmarks and controls for specific services should override the "service" tag
locals {
  github_sherlock_common_tags = {
    category = "Compliance"
    plugin   = "github"
    service  = "GitHub"
  }
}
