#alter a glassfish clusters message queue - more docs to follow
define glassfish::jmscluster (
  $clustertype      = 'enhanced',
  $dbvendor         = 'postgressql',
  $dbuser           = '',
  $dburl            = 'jdbc:://localhost/',
  $clusterName      = $name,
  $ensure           = 'present',
  $asadmin_user     = $glassfish::asadmin_user,
  $asadmin_passfile = $glassfish::asadmin_passfile,
  $asadmin_password = $glassfish::asadmin_password
) {
  

  # Create the cluster
  jmscluster { $clusterName:
    ensure       => $ensure,
    clustertype  => $clustertype,
    dbvendor     => $dbvendor,
    user         => asadmin_user,
    passwordfile => $asadmin_passfile,
    dbuser       => $dbuser,
    dburl        => $dburl,

  }

}
