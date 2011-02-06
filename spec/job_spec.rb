require 'rspec'
require 'vmware'

describe VMWare::Job do
  
  context 'before execution' do
    
    before(:each) do
      VMWare::Job.clear_all!
      @job = VMWare::Job.new {|job, context|}
      @job.on(:complete){|job, context, event|}
      @job.on(:join){|job, context|}
    end
    
    it 'should have an empty context' do
      @job.context.should be_kind_of(Hash)
      @job.context.length.should equal 0
    end
  
    it 'should have a task to perform' do
      
    end
  
    it 'should not yet have a handle id' do
    
    end
  
    it 'can have event handlers defined' do
    
    end
  
    it 'can have a join proc defined' do
    
    end
  
    it 'should have a free handler assigned' do
    
    end
  
  end
  
  context 'during execution' do
    
    it 'should handle callbacks' do

    end

    it 'should operate synchronously, or asynchronously' do

    end

    it 'should allow access to properties' do

    end

    it 'should track handles' do

    end
    
  end
  
  context 'after execution' do
    
    it 'should have a handle id' do

    end

    it 'should free used handles' do

    end
    
  end
  
end
