# @summary Add the blank line after the services in the MOTD
#
# Add the blank line after the services in the MOTD
#
# @api private
class profile_metadata::service::motd_blank {
  meta_motd::fragment { $title:
    order   => '16',
    content => "\n",
  }
}
