# Support defining metadata for a node (e.g profile::metadata::service)
class profile::metadata {
  concat { '/opt/puppetlabs/facter/facts.d/profile_metadata.yaml':
    owner => 'root',
    group => 'root',
    mode  => '0444',
  }

  concat::fragment { 'profile::metadata header':
    target  => '/opt/puppetlabs/facter/facts.d/profile_metadata.yaml',
    order   => '00',
    content => "---\nprofile_metadata:\n",
  }

  concat::fragment { 'profile::metadata services header':
    target  => '/opt/puppetlabs/facter/facts.d/profile_metadata.yaml',
    order   => '10',
    content => "  services:\n",
  }
}
