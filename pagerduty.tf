# Configure the PagerDuty provider
provider "pagerduty" {
  token = "${var.pagerduty_token}"
}

# Create a PagerDuty team
resource "pagerduty_team" "sre_engineering" {
  name        = "SRE"
  description = "All SRE"
}

# Create a PagerDuty user
resource "pagerduty_user" "pradeep" {
  name  = "Pradeep Kumar"
  email = "pradeepkumar@gmail.com"
  teams = ["${pagerduty_team.engineering.id}"]
}

resource "pagerduty_service" "web_app_example" {
  name                    = "Web_App"
  auto_resolve_timeout    = 14400
  acknowledgement_timeout = 600
  escalation_policy       = "${pagerduty_escalation_policy.example.id}"
  alert_creation          = "create_incidents"
}

resource "pagerduty_escalation_policy" "ask" {
  name      = "SRE Engineering Ask Policy"
  num_loops = 2

  rule {
    escalation_delay_in_minutes = 10

    target {
      type = "user"
      id   = "${pagerduty_user.example.id}"
    }
  }
}
