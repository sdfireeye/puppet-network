# == Definition: network::if::dynamic
#
# Creates a normal interface with dynamic IP information.
#
# === Parameters:
#
#   $ensure        - required - up|down
#   $macaddress    - optional - defaults to macaddress_$title
#   $bootproto     - optional - defaults to "dhcp"
#   $userctl       - optional - defaults to false
#   $mtu           - optional
#   $dhcp_hostname - optional
#   $ethtool_opts  - optional
#   $ipv6address   - optional
#   $ipv6init      - optional - defaults to true
#   $ipv6gateway   - optional
#   $ipv6autoconf  - optional - defaults to false
#
# === Actions:
#
# Deploys the file /etc/sysconfig/network-scripts/ifcfg-$name.
#
# === Sample Usage:
#
#   network::if::dynamic { 'eth2':
#     ensure     => 'up',
#     macaddress => $::macaddress_eth2,
#   }
#
#   network::if::dynamic { 'eth3':
#     ensure     => 'up',
#     macaddress => 'fe:fe:fe:fe:fe:fe',
#     bootproto  => 'bootp',
#   }
#
#
#
define network::if::dynamic_ipv4_static_ipv6 (
  $ensure,
  $macaddress = undef,
  $bootproto = 'dhcp',
  $userctl = false,
  $mtu = undef,
  $dhcp_hostname = undef,
  $ethtool_opts = undef,
  $linkdelay = undef,
  $ipv6address = undef,
  $ipv6init = true,
  $ipv6gateway = undef,
  $ipv6autoconf = false,
) {
  # Validate our regular expressions
  $states = [ '^up$', '^down$' ]
  validate_re($ensure, $states, '$ensure must be either "up" or "down".')

  if ! is_mac_address($macaddress) {
    # Strip off any tailing VLAN (ie eth5.90 -> eth5).
    $title_clean = regsubst($title,'^(\w+)\.\d+$','\1')
    $macaddy = getvar("::macaddress_${title_clean}")
  } else {
    $macaddy = $macaddress
  }
  # Validate booleans
  validate_bool($userctl)

  network_if_base { $title:
    ensure        => $ensure,
    ipaddress     => '',
    netmask       => '',
    gateway       => '',
    macaddress    => $macaddy,
    bootproto     => $bootproto,
    userctl       => $userctl,
    mtu           => $mtu,
    dhcp_hostname => $dhcp_hostname,
    ethtool_opts  => $ethtool_opts,
    linkdelay     => $linkdelay,
    ipv6address   => $ipv6address,
    ipv6init      => $ipv6init,
    ipv6gateway   => $ipv6gateway,
    ipv6autoconf  => $ipv6autoconf,
  }
} # define network::if::dynamic_ipv4_static_ipv6
