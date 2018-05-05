# Add the blank line after the services in the MOTD
class profile::metadata::service::motd_blank {
  profile::motd::fragment { $title:
    order   => '16',
    content => "\n",
  }
}
