require 'rubygems'

Puppet::Type.newtype(:jmscluster) do
  @doc = "Manage JMS cluster resources "

  ensurable

  newparam(:name) do
    desc "The JMS cluster name."
    isnamevar
    
    validate do |value|
      unless value =~ /^\w+[\w=\-\/.]*$/
         raise ArgumentError, "%s is not a valid cluster resource name." % value
      end
    end
  end
 # args << "configure-jms-cluster --passwordfile" << @resource[:dbpasswordfile]
  newparam(:clustertype) do
    desc 'The jms cluster type valid variables are conventional|enhanced'
     validate do |value|
       unless value == 'conventional' || value == 'enhanced'
         raise ArguementError, '%s Is not a valid clusterType - permitted variables are conventional or enhanced'
       end
     end
  end
  newparam(:configstoretype) do
  desc 'The jms config store type valid variables are masterbroker|shareddb'
   validate do |value|
     unless value == 'masterbroker' || value == 'shareddb'
       raise ArguementError, '%s Is not a valid configstoretype - permitted variables are masterbroker or shareddb'
     end
   end
  end

  newparam(:dbvendor)do
  desc 'The dbvendor for the JMS message store valid inputs are postgressql|mysql|oracle'
   validate do |value|
     unless value == 'postgressql' || value == 'mysql' || value == 'oracle'
       raise ArguementError, '%s Is not a valid dbvendor - permitted variables are postgressql|mysql|oracle'
     end
   end
  end
  
  newparam(:dbuser)do
  desc 'The database user for the JMS message store'

  end  
  
  newparam(:dburl)do
  desc 'The jdbc url for the JMS message store database'
    validate do |value|
          unless value =~ '((jdbc):((//)|(\\\\))+[\\w\\d:#@%/;$()~_?\\+-=\\\\\\.&]*)'
             raise ArgumentError, "%s is not a valid jdbc url." % value
          end
        end
  end
  
  newparam(:passwordfile) do
    desc "The file containing the password for the user."

    validate do |value|
      unless File.exists? value
        raise ArgumentError, "%s does not exists" % value
      end
    end
  end  
   
  # Validate mandatory params
  validate do
    raise Puppet::Error, 'Cluster name is required' unless self[:name]
  end
  
  validate do
    raise Puppet::Error, 'Cluster type is required' unless self[:clustertype]
  end
  
  
  # Autorequire the user running command
  autorequire(:user) do
    self[:user]
  end
  
  # Autorequire the password file
  autorequire(:file) do
    self[:passwordfile]
  end
  
  # Autorequire the relevant domain
  autorequire(:domain) do
    self.catalog.resources.select { |res|
      next unless res.type == :domain
      res if res[:portbase] == self[:portbase]
    }.collect { |res|
      res[:name]
    }
  end
end
