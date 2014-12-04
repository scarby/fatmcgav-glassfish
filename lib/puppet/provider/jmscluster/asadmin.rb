require 'puppet/provider/asadmin'
require 'rubygems'
require 'json'
require 'net/http'
Puppet::Type.type(:jmscluster).provide(:asadmin,
                                   :parent => Puppet::Provider::Asadmin) do
  desc "Glassfish JMS cluster support."

  def create
    imqpersisturl = "imq.persist.jdbc.postgresql.opendburl=" + @resource[:dburl].gsub(':', '\\:')
    imqpersisturl = "'" + imqpersisturl.gsub(':', '\\:') + "'"
    # Start a new args array
    args = Array.new
    args << "configure-jms-cluster"
    args << "--clustertype" << @resource[:clustertype]
    args << "--dbvendor" << @resource[:dbvendor]
    args << "--dbuser" << @resource[:dbuser]
    args << "--dburl" << @resource[:dburl]
    args << "--property" << imqpersisturl
    # SSH details are optional
    args << @resource[:name]
    
    # Run the create command
    asadmin_exec(args)

    #we now need to fix a really annoying typo in 3.1.X
    if @resource[:dbvendor] == 'postgressql' then
      asadmin_exec(['stop-domain', @resource[:domain]])
      command = "sed -i 's/postgressql/postgresql/' " +  @resource[:parent_dir] + "/" + @resource[:install_dir] + "/glassfish/domains/" + @resource[:domain] + "/config/domain.xml"
      Puppet.debug("replacing incorrect config -- #{command}")
      sed = `#{command}`
      asadmin_exec(['start-domain', @resource[:domain]])
    end

  end


  def exists?
    #need to make a call to the glassfish domain rest URL to confirm cluster settings
    #we need to do this using curl for ubuntu ruby reasons (will update to check)
  #  uri = URI("https://" + @resource[:dashost] + ":" @resource[:dasport] "/management/domain/configs/config/" + @resource[:name] + "-config/availability-service/jms-availability.json")
  #  http = Net::HTTP.new(uri.host, uri.port)
  #  http.use_ssl = true
  #  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  #  http.ssl_version = :SSLv3
  #  request = Net::HTTP::Get.new(uri.request_uri)
  #  request.basic_auth @resource[:user], @resource[:password]
  #  response = http.request(request)
  #  parsed = JSON.parse(response.body)

    uri = "https://" + @resource[:dashost] + ":" @resource[:dasport] "/management/domain/configs/config/" + @resource[:name] + "-config/availability-service/jms-availability.json"
    command = "curl -ssl3 --user " + @resource[:user] + ":" + @resource[:password] +" --insecure " + uri
    response = `#{command}`
    parsed = JSON.parse(response)

    if  parsed['extraProperties']['entity']['dbUrl'] == @resource[:dburl] &&  parsed['extraProperties']['entity']['dbUsername'] == @resource[:dbuser]
      then
      return true
    else
      return false
    end
  end
  def destroy
    puts 'a cluster configuration cannot be removed'
    return false
  end
end
