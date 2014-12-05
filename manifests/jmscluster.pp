#alter a glassfish clusters message queue - more docs to follow
define glassfish::jmscluster (
  $clustertype      = 'enhanced',
  $dbvendor         = 'postgresql',
  $dbuser           = '',
  $dburl            = 'jdbc:://localhost/',
  $clusterName      = $name,
  $ensure           = 'present',
  $asadmin_user     = $glassfish::user,
  $asadmin_passfile = $glassfish::asadmin_passfile,
  $asadmin_password = $glassfish::asadmin_password,
  $parent_dir       = $glassfish::parent_dir,
  $install_dir      = $glassfish::install_dir,
  $domain           = $glassfish::domain_name,
  $das_host         = 'localhost'
) {
  

  # Create the cluster
  jmscluster { $clusterName:
    ensure       => $ensure,
    clustertype  => $clustertype,
    dbvendor     => $dbvendor,
    user         => $asadmin_user,
    passwordfile => $asadmin_passfile,
    password     => $asadmin_password,
    dbuser       => $dbuser,
    dburl        => $dburl,
    parent_dir   => $parent_dir,
    install_dir  => $install_dir,
    domain       => $domain,
    $dashost     => $das_host
  }

}
