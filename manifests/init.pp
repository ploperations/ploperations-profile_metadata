# @summary Support defining metadata for a node (e.g profile_metadata::service)
#
# Support defining metadata for a node (e.g profile_metadata::service)
#
# @api private
class profile_metadata {

  case $facts['os']['family'] {
    'windows': {
      $common_appdata_dir = regsubst($facts['puppet_agent_appdata'], '\\\\', '/')
      $facts_folder       = "${common_appdata_dir}/PuppetLabs/facter/facts.d"
      $admin_user         = 'Administrator'
      $admin_group        = 'Administrators'
    }
    default: {
      $facts_folder = '/opt/puppetlabs/facter/facts.d'
      $admin_user   = 'root'
      $admin_group  = 'root'
    }
  }

  concat { "${facts_folder}/profile_metadata.yaml":
    owner => $admin_user,
    group => $admin_group,
    mode  => '0444',
  }

  concat::fragment { 'profile_metadata header':
    target  => "${facts_folder}/profile_metadata.yaml",
    order   => '00',
    content => "---\nprofile_metadata:\n",
  }

  concat::fragment { 'profile_metadata services header':
    target  => "${facts_folder}/profile_metadata.yaml",
    order   => '10',
    content => "  services:\n",
  }
}
