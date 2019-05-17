#
# == Class: intermapper::install
#
# Manage the installation of Intermapper
class intermapper::install {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $intermapper::package_manage {
    package { $intermapper::package_name :
      ensure   => $intermapper::package_ensure,
      source   => $intermapper::package_source,
      provider => $intermapper::package_provider,
    }
  }

  # Install NAGIOS plugins, which are compatible with InterMapper,
  # as requested.
  if $intermapper::nagios_manage
  and ! empty($intermapper::nagios_plugins_package_name) {
    ensure_packages($intermapper::nagios_plugins_package_name)
  }

  # Install requested fonts
  if $intermapper::font_package_name {
    ensure_packages($intermapper::font_package_name)
  }
}
