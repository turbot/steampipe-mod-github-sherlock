mod "github_sherlock" {
  # hub metadata
  title         = "GitHub Sherlock"
  description   = "Interrogate your GitHub resources with the help of the world's greatest detectives: Steampipe + Sherlock."
  color         = "#FF9900"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/github-sherlock.svg"
  categories    = ["GitHub", "Sherlock", "Software Development"]

  opengraph {
    title        = "Steampipe Mod to Analyze GitHub"
    description  = "Interrogate your GitHub resources with the help of the world's greatest detectives: Steampipe + Sherlock."
    image        = "/images/mods/turbot/github-sherlock-social-graphic.png"
  }
}
