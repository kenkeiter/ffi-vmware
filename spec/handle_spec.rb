require 'rspec'
require 'ffi'
require 'vmware'

describe VMWare::VIX::Handle do
  
  context 'before registration' do
    
    before(:each) do
      @handle = VMWare::VIX::Handle.new
    end
    
    it 'should be an invalid handle' do
      @handle.id.should == 0
      @handle.ptr.should be_kind_of(FFI::MemoryPointer)
      @handle.ptr.get_int(0).should == 0
      @handle.valid?.should be_false
    end
    
    it 'should not attempt to make VIX calls' do
      expect {@handle[:something]}.to raise_error(RuntimeError)
      expect {@handle.property(:something)}.to raise_error(RuntimeError)
      expect {@handle.property_type(:something)}.to raise_error(RuntimeError)
      expect {@handle.handle_type}.to raise_error(RuntimeError)
    end
    
  end
  
  context 'after registration' do
    
    before(:each) do
      VMWare::VIX::Handle.clear_all!
      @handle = VMWare::VIX::Handle.new
      @handle.id = 1
    end
    
    it 'should be a singleton' do
      VMWare::VIX::Handle.exists?(1).should be_true
      VMWare::VIX::Handle.exists?(2).should be_false
      
      @handle.should == VMWare::VIX::Handle.from_id(1)

      ptr = FFI::MemoryPointer.new(:int); ptr.write_int(1)
      @handle.should == VMWare::VIX::Handle.from_ptr(ptr)
    end
    
    it 'should be valid' do
      @handle.id.should_not == 0
      @handle.ptr.should be_kind_of(FFI::MemoryPointer)
      @handle.ptr.get_int(0).should_not == 0
      @handle.valid?.should be_true
    end
    
    it 'should allow reassignment of its id' do
      @handle.id = 2
      @handle.valid?.should be_true
      VMWare::VIX::Handle.from_id(1).should be_nil
    end
    
  end
  
end