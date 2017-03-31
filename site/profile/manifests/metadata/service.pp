# Define information about a service
#
# $title This should always be the name of the enclosing class, which will be
#   available in $title. The only case where this will be different is within
#   defined types.
#
# $owner_uid is the LDAP uid of the owner of the service. If there are multiple
#   owners, pick one. This may only be set to `undef` temporarily.
# $team is the team that owns the service. This should generally be infracore,
#   re, qe, or itops.
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
define profile::metadata::service (
  Optional[String[1]] $owner_uid,
  String[1] $team,
  Optional[Array[Pattern[/@/], 1]] $end_users,
  String[1] $escalation_period = 'pdx-workhours',
  Optional[String[1]] $downtime_impact = undef,
  Optional[String[1]] $notes = undef,
  Array[String[1]] $doc_urls = [],
  Pattern[/\A([a-z][a-z0-9_]*)?(::[a-z][a-z0-9_]*)*\Z/] $class_name = $title,
  String[1] $human_name = $title,
  Array[String[1]] $other_fqdns = [],
) {
  include ::profile::metadata

  concat::fragment { "profile::metadata::services ${title}":
    target  => '/opt/puppetlabs/facter/facts.d/profile_metadata.yaml',
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
      },
      # to_yaml outputs multiline strings with | so indenting is safe
    ].to_yaml().regsubst("^---", "", "G").regsubst("^", "    ", "G"),
  }
}
