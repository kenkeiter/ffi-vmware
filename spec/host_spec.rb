require 'rspec'
require 'vmware'

describe VMWare::Host do
  
  context 'before connection' do
  
    it 'should connect' do
      VMWare::Host.clear_all!
      @host = VMWare::Host.new(
        :hostname => 'https://localhost:8333/sdk', 
        :username => 'root', :password => 'Y1gtkfehw1')
      @host.connect
      puts "Inventory: #{@host.inventory.inspect}"
      @host.disconnect
    end
    
  end
  
end