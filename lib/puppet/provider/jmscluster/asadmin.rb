require 'puppet/provider/asadmin'
require 'rubygems'
require 'json'
require 'net/http'
Puppet::Type.type(:jmscluster).provide(:asadmin,
                                   :parent => Puppet::Provider::Asadmin) do
  desc "Glassfish JMS cluster support."

  def create
    # Start a new args array
    args = Array.new
    args << "configure-jms-cluster --passwordfile" << @resource[:dbpasswordfile]
    args << "--clustertype" << @resource[:clustertype]
    args << "--dbvendor" << @resource[:dbvendor]
    args << "--dbuser" << @resource[:dbuser]
    args << "--dburl" << @resource[:dburl]
    # SSH details are optional
    args << @resource[:name]
    
    # Run the create command
    asadmin_exec(args)

  end


  def exists?
    #need to make a call to the glassfish domain rest URL to confirm cluster settings
    
    uri = URI("https://localhost:4848/management/domain/configs/config/" + @resource[:name] + "-config/availability-service/jms-availability.json")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.ssl_version = :SSLv3
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth @resource[:user], @resource[:password]
    response = http.request(request)
    parsed = JSON.parse(response.body)
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
