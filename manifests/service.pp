# @summary Define information about a service
#
# Define information about a service. The service's title is automatically added
# to the MOTD and all the information is added to a structured fact
# named `profile_metadata`.
#
# `$title`: This should always be the name of the enclosing class, which will be
#   available in `$title`. The only case where this will be different is within
#   defined types.
#
# @param [Optional[String[1]]] owner_uid
#   The LDAP uid of the owner of the service. If there are multiple
#   owners, pick one. This may only be set to `undef` temporarily as all services
#   need to have an owner... even when nobody want it.
#
# @param [Optional[String[1]]] team
#   The team that owns the service. At Puppet, this should generally be
#   infracore, re, qe, or itops. This may only be set to `undef` temporarily 
#   as all services need to owned by a team... even when nobody want it.
#
# @param [Optional[Array[Pattern[/@/], 1]]] end_users
#   An array of email addresses to notify when there are changes to
#   the service that will be visible outside of `$team`. For example,
#   `all@puppet.com` is appropriate for JIRA. This may only be set to `undef`
#   temporarily. If only `$team` will see the changes then `$team`'s email should
#   be used.
#
# @param [String[1]] escalation_period
#   A description of when we should escalate to `$team` if
#   the service goes down and the on call person cannot fix it. For example:
#     - pdx-workhours
#     - 24/7
#     - workdays
#
# @param [Optional[String[1]]] downtime_impact
#   A description of the impact of downtime, e.g.
#   "Development work will be blocked because their changes cannot be tested
#   and thus cannot be merged." Use multiple lines and markdown as appropriate.
#
# @param Optional[String[1]] notes
#   General notes for things not covered elsewhere. Use multiple lines
#   and markdown as appropriate.
#
# @param Array[String[1]] doc_urls
#   An array of URLs to documentation (e.g. Confluence).
#
# @param String[1] human_name is a human friendly name for the service. For example,
#   "Internal InfraCore CI".
#
# @param Array[String[1]] other_fqdns 
#   Other FQDNs that resolve to this host that are used by the
#   service. For example, the $site_alias of a Jenkins master.
#
# @example A service definition on a Puppet Master included in `profile::pe::master`
#   profile_metadata::service { $title:
#     human_name        => 'Puppet Master',
#     owner_uid         => 'john.doe',
#     team              => infracore,
#     end_users         => ['notify-infracore@example.com'],
#     escalation_period => 'global-workhours',
#     downtime_impact   => "Can't make changes to infrastructure",
#     doc_urls          => [
#       'https://example.com/our-pe-docs',
#     ],
#   }
#
# @example The resulting fact from the definition above as shown by `sudo facter -p profile_metadata` on the master
#   {
#     services => [
#       {
#         class_name => "profile::pe::master",
#         doc_urls => [
#           "https://example.com/our-pe-docs"
#         ],
#         downtime_impact => "Can't make changes to infrastructure",
#         end_users => [
#           "notify-infracore@example.com"
#         ],
#         escalation_period => "global-workhours",
#         human_name => "Puppet Master",
#         other_fqdns => [],
#         owned => true,
#         owner_uid => "john.doe",
#         team => "infracore"
#       }
#     ]
#   }
#
# @example The two lines this definition adds to the bottom of the MOTD
#   Puppet Master
#     profile::pe::master owned by team infracore
#
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
