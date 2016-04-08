require 'serverspec'

# Start apache
# Start MySQL


services = []
if property['service']['httpd'] == true
    services.push('httpd')
end
if property['service']['mysqld'] == true
    services.push('mysqld')
end
if property['service']['webmin'] == true
    services.push('webmin')
end
if property['service']['usermin'] == true
    services.push('usermin')
end
if property['service']['jenkins'] == true
    services.push('jenkins')
end
if property['service']['docker'] == true
    services.push('docker')
end
if property['service']['ntp'] == true
    services.push('ntp')
end

#services = ['httpd','mysqld']
services.each do | service |
    describe service("#{service}") do
        it { should be_enabled }
        it { should be_running }
    end
end
