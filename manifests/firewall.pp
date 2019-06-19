# Manage InterMapper firewall entries
class intermapper::firewall {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # Poke IPv4 firewall holes, if requested
  if $intermapper::firewall_ipv4_manage {
    firewall {
      '098 IPv4 InterMapper TCP ports':
        * => $intermapper::firewall_defaults + {
          dport => $intermapper::firewall_ports_tcp,
          proto => 'tcp',
        };
      '099 IPv4 InterMapper UDP ports':
        * => $intermapper::firewall_defaults + {
          dport => $intermapper::firewall_ports_udp,
          proto => 'udp',
        };
    }
  }

  # Poke IPv6 firewall holes, if requested
  if $intermapper::firewall_ipv6_manage {
    firewall {
      '098 IPv6 InterMapper TCP ports':
        * => $intermapper::firewall_defaults + {
          dport    => $intermapper::firewall_ports_tcp,
          proto    => 'tcp',
          provider => 'ip6tables',
        };
      '099 IPv6 InterMapper UDP ports':
        * => $intermapper::firewall_defaults + {
          dport    => $intermapper::firewall_ports_udp,
          proto    => 'udp',
          provider => 'ip6tables',
        };
    }
  }
}
