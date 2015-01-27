class intermapper::install {
  # TODO: Consider making this class private?
  #private("Only should be called from the ${module_name} module")

  if $::intermapper::package_manage {
    package { $::intermapper::package_name :
      source   => $::intermapper::package_source,
      provider => $::intermapper::package_provider,
      ensure   => $::intermapper::package_ensure,
    }
  }

}
