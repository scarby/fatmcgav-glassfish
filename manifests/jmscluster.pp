define glassfish::jmscluster (
  $clustertype      = 'enhanced',
  $dbvendor         = 'postgressql',
  $dbuser           = '',
  $dburl            = 'jdbc:://localhost/',
  $clusterName      = $name,
  $ensure           = 'present',
  $asadmin_user     = $glassfish::asadmin_user,
  $asadmin_passfile = $glassfish::asadmin_passfile,) {
  

  # Create the cluster
  jmscluster { $clusterName:
    ensure           => $ensure,
    clustertype      => $clustertype,
    dbvendor         => $dbvendor,
    passwordfile     => $asadmin_passfile,
    dbuser           => $dbuser,
    dburl            => $dburl,

  }

}
