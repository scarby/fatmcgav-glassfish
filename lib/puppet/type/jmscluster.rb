require 'rubygems'
require 'uri'

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
         raise ArgumentError, '%s Is not a valid clusterType - permitted variables are conventional or enhanced'
       end
     end
  end
  newparam(:configstoretype) do
  desc 'The jms config store type valid variables are masterbroker|shareddb'
   validate do |value|
     unless value == 'masterbroker' || value == 'shareddb'
       raise ArgumentError, '%s Is not a valid configstoretype - permitted variables are masterbroker or shareddb'
     end
   end
  end

  newparam(:dbvendor)do
  desc 'The dbvendor for the JMS message store valid inputs are postgressql|mysql|oracle'
   validate do |value|
     unless value == 'postgressql' || value == 'mysql' || value == 'oracle' || value == 'postgresql'
       raise ArgumentError, '%s Is not a valid dbvendor - permitted variables are postgressql|mysql|oracle'
     end
   end
  end
  
  newparam(:dbuser)do
  desc 'The database user for the JMS message store'

  end  
  
  newparam(:dburl)do
  desc 'The jdbc url for the JMS message store database'
    validate do |value|
          unless value =~ /\A#{URI::regexp}\z/
             raise ArgumentError, "%s is not a valid jdbc url." % value
          end
        end
  end
  
  newparam(:passwordfile) do
    desc "The file containing the password for the user."

    validate do |value|
      unless  value != ''
        raise ArgumentError, "%s does not exists" % value
      end
    end
  end  

  newparam(:password) do
    desc "The file containing the password for the user."

    validate do |value|
      unless  value != ''
        raise ArgumentError, "%s does not exists" % value
      end
    end
  end
newparam(:dashost) do
  desc "The Glassfish DAS hostname."
  defaultto 'localhost'
end
  
newparam(:dasport) do
  desc "The Glassfish DAS port. Default: 4848"
  defaultto '4848'

  validate do |value|
    raise ArgumentError, "%s is not a valid das port." % value unless value =~ /^\d{4,5}$/
  end  
end
newparam(:asadminuser) do
  desc "The internal Glassfish user asadmin uses. Default: admin"
  defaultto 'admin'

  validate do |value|
    unless value =~ /^[\w-]+$/
        raise ArgumentError, "%s is not a valid asadmin user name." % value
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

  newparam(:user) do
    desc "The user to run the command as."
    defaultto 'glassfish'

    validate do |value|
      unless Puppet.features.root?
        self.fail "Only root can execute commands as other users"
      end
      unless value =~ /^[\w-]+$/
         raise ArgumentError, "%s is not a valid user name." % value
      end
    end
  end

  newparam(:domain) do
    desc "The domain within which the cluster exists."

    validate do |value|
      unless  value != ''
        raise ArgumentError, "%s does not exists" % value
      end
    end
  end
  newparam(:parent_dir) do
    desc "The parent dir for the glassfish installation"

    validate do |value|
      unless  value != ''
        raise ArgumentError, "%s does not exists" % value
      end
    end
  end
  newparam(:install_dir) do
    desc "The glassfish installation directory"

    validate do |value|
      unless  value != ''
        raise ArgumentError, "%s does not exists" % value
      end
    end
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
 # autorequire(:domain) do
 #   self.catalog.resources.select { |res|
 #     next unless res.type == :domain
 #     res if res[:portbase] == self[:portbase]
 #   }.collect { |res|
 #     res[:name]
#    }
#  end
end
