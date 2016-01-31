require 'serverspec'

# Start apache
# Start MySQL
services = ['httpd','mysql']
services.each do | service |
    describe service("#{service}") do
        it { should be_enabled }
        it { should be_running }
    end
end
