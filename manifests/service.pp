# Define information about a service
#
# $title This should always be the name of the enclosing class, which will be
#   available in $title. The only case where this will be different is within
#   defined types.
#
# $owner_uid is the LDAP uid of the owner of the service. If there are multiple
#   owners, pick one. This may only be set to `undef` temporarily.
# $team is the team that owns the service. This should generally be infracore,
#   re, qe, or itops. This may only be set to `undef` temporarily.
# $end_users is an array of email addresses to notify when there are changes to
#   the service that will be visible outside of $team. For example,
#   all@puppet.com is appropriate for JIRA. This may only be set to `undef`
#   temporarily.
# $escalation_period is a description of when we should escalate to $team if
#   the service goes down and the on call person cannot fix it. For example:
#     * pdx-workhours
#     * 24/7
#     * workdays
# $downtime_impact is a description of the impact of downtime, e.g.
#   "Development work will be blocked because their changes cannot be tested
#   and thus cannot be merged." Use multiple lines and markdown as appropriate.
# $notes are general notes for things not covered elsewhere. Use multiple lines
#   and markdown as appropriate.
# $doc_urls is an array of URLs to documentation (e.g. Confluence).
# $human_name is a human friendly name for the service. For example,
#   "Internal InfraCore CI".
# $other_fqdns are other FQDNs that resolve to this host that are used by the
#   service. For example, the $site_alias of a Jenkins master.
define profile_metadata::service (
  Optional[String[1]]                                   $owner_uid          = undef,
  Optional[String[1]]                                   $team               = undef,
  Optional[Array[Pattern[/@/], 1]]                      $end_users          = undef,
  String[1]                                             $escalation_period  = 'pdx-workhours',
  Optional[String[1]]                                   $downtime_impact    = undef,
  Optional[String[1]]                                   $notes              = undef,
  Array[String[1]]                                      $doc_urls           = [],
  Pattern[/\A([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*\Z/] $class_name         = $title,
  String[1]                                             $human_name         = $title,
  Array[String[1]]                                      $other_fqdns        = [],
) {
  include profile_metadata

  if $team {
    $owned_by = "team ${team}"
  } elsif $owner_uid {
    $owned_by = $owner_uid
  } else {
    $owned_by = 'nobody'
  }

  if $owned_by == 'nobody' {
    $owned = false
  } else {
    $owned = true
  }

  include profile_metadata::service::motd_blank
  meta_motd::fragment { "profile_metadata::service ${title}":
    order   => '15',
    content => @("FRAGMENT"),
      ${human_name}
        ${class_name} owned by ${owned_by}
      | FRAGMENT
  }

  concat::fragment { "profile_metadata::services ${title}":
    target  => "${profile_metadata::facts_folder}/profile_metadata.yaml",
    order   => '11',
    content => [
      {
        human_name        => $human_name,
        class_name        => $class_name,
        owner_uid         => $owner_uid,
        team              => $team,
        escalation_period => $escalation_period,
        downtime_impact   => $downtime_impact,
        end_users         => $end_users,
        notes             => $notes,
        doc_urls          => $doc_urls,
        other_fqdns       => $other_fqdns,
        owned             => $owned,
      },
      # to_yaml outputs multiline strings with | so indenting is safe
    ].to_yaml().regsubst('^---', '', 'G').regsubst('^', '    ', 'G'),
  }
}
