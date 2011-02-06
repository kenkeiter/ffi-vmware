# Sample Code -- VMWare VIX FFI library.
# Copyright 2011 Kenneth Keiter <ken@kenkeiter.com>
# All Rights Reserved.

require 'ffi'

module VMWare

  module VIX
  
    extend FFI::Library
    ffi_lib 'libvixAllProducts' #typically under /usr/lib/vmware-vix/lib
    
    # Handles
  
    enum :VixHandle, [:VIX_INVALID_HANDLE, 0]
    enum :VixHandleType, [
      :VIX_HANDLETYPE_NONE, 0,
      :VIX_HANDLETYPE_HOST, 2,
      :VIX_HANDLETYPE_VM, 3,
      :VIX_HANDLETYPE_NETWORK, 5,
      :VIX_HANDLETYPE_JOB, 6,
      :VIX_HANDLETYPE_SNAPSHOT, 7,
      :VIX_HANDLETYPE_PROPERTY_LIST, 9,
      :VIX_HANDLETYPE_METADATA_CONTAINER, 11
    ]
  
    # Error Handling
    
    typedef :uint64, :VixError
    attach_function :Vix_GetErrorText, [:VixError, :string], :string
  
    # Properties
    
    # VixPropertyTypes mapped to their FFI::MemoryPointer counterparts
    VixPropertyType = enum(
      :pointer, 0,
      :int, 1,
      :pointer, 2, # string
      :int, 3, # boolean
      :int, 4, # handle
      :int64, 5,
      :pointer, 6
    )
    
    enum :VixPropertyID, [
      :VIX_PROPERTY_NONE, 0,
    
      # Props used by several handle types
      :VIX_PROPERTY_META_DATA_CONTAINER, 2,
    
      # VIX_HANDLETYPE_HOST props
      :VIX_PROPERTY_HOST_HOSTTYPE, 50,
      :VIX_PROPERTY_HOST_API_VERSION, 51,
    
      # VIX_HANDLETYPE_VM properties
      :VIX_PROPERTY_VM_NUM_VCPUS, 101,
      :VIX_PROPERTY_VM_VMX_PATHNAME, 103,
      :VIX_PROPERTY_VM_VMTEAM_PATHNAME, 105,
      :VIX_PROPERTY_VM_MEMORY_SIZE, 106,
      :VIX_PROPERTY_VM_READ_ONLY, 107,
      :VIX_PROPERTY_VM_NAME, 108,
      :VIX_PROPERTY_VM_GUESTOS, 109,
      :VIX_PROPERTY_VM_IN_VMTEAM, 128,
      :VIX_PROPERTY_VM_POWER_STATE, 129,
      :VIX_PROPERTY_VM_TOOLS_STATE, 152,
      :VIX_PROPERTY_VM_IS_RUNNING, 196,
      :VIX_PROPERTY_VM_SUPPORTED_FEATURES, 197,
      :VIX_PROPERTY_VM_IS_RECORDING, 236,
      :VIX_PROPERTY_VM_IS_REPLAYING, 237,
    
      # Result props, returned by various procedures
      :VIX_PROPERTY_JOB_RESULT_ERROR_CODE, 3000,
      :VIX_PROPERTY_JOB_RESULT_VM_IN_GROUP, 3001,
      :VIX_PROPERTY_JOB_RESULT_USER_MESSAGE, 3002,
      :VIX_PROPERTY_JOB_RESULT_EXIT_CODE, 3004,
      :VIX_PROPERTY_JOB_RESULT_COMMAND_OUTPUT, 3005,
      :VIX_PROPERTY_JOB_RESULT_HANDLE, 3010,
      :VIX_PROPERTY_JOB_RESULT_GUEST_OBJECT_EXISTS, 3011,
      :VIX_PROPERTY_JOB_RESULT_GUEST_PROGRAM_ELAPSED_TIME, 3017,
      :VIX_PROPERTY_JOB_RESULT_GUEST_PROGRAM_EXIT_CODE, 3018,
      :VIX_PROPERTY_JOB_RESULT_ITEM_NAME, 3035,
      :VIX_PROPERTY_JOB_RESULT_FOUND_ITEM_DESCRIPTION, 3036,
      :VIX_PROPERTY_JOB_RESULT_SHARED_FOLDER_COUNT, 3046,
      :VIX_PROPERTY_JOB_RESULT_SHARED_FOLDER_HOST, 3048,
      :VIX_PROPERTY_JOB_RESULT_SHARED_FOLDER_FLAGS, 3049,
      :VIX_PROPERTY_JOB_RESULT_PROCESS_ID, 3051,
      :VIX_PROPERTY_JOB_RESULT_PROCESS_OWNER, 3052,
      :VIX_PROPERTY_JOB_RESULT_PROCESS_COMMAND, 3053,
      :VIX_PROPERTY_JOB_RESULT_FILE_FLAGS, 3054,
      :VIX_PROPERTY_JOB_RESULT_PROCESS_START_TIME, 3055,
      :VIX_PROPERTY_JOB_RESULT_VM_VARIABLE_STRING, 3056,
      :VIX_PROPERTY_JOB_RESULT_PROCESS_BEING_DEBUGGED, 3057,
      :VIX_PROPERTY_JOB_RESULT_SCREEN_IMAGE_SIZE, 3058,
      :VIX_PROPERTY_JOB_RESULT_SCREEN_IMAGE_DATA, 3059,
      :VIX_PROPERTY_JOB_RESULT_FILE_SIZE, 3061,
      :VIX_PROPERTY_JOB_RESULT_FILE_MOD_TIME, 3062,
      :VIX_PROPERTY_JOB_RESULT_EXTRA_ERROR_INFO, 3084,
    
      # Event Props
      :VIX_PROPERTY_FOUND_ITEM_LOCATION, 4010,
    
      # VIX_HANDLETYPE_SNAPSHOT props
      :VIX_PROPERTY_SNAPSHOT_DISPLAYNAME, 4200,
      :VIX_PROPERTY_SNAPSHOT_DESCRIPTION, 4201,
      :VIX_PROPERTY_SNAPSHOT_POWERSTATE, 4205,
      :VIX_PROPERTY_SNAPSHOT_IS_REPLAYABLE, 4207,
    
      # VM Encryption Props
      :VIX_PROPERTY_VM_ENCRYPTION_PASSWORD, 7001
    ]
  
    # Note: Vix_GetProperties, Vix_GetPropertyType return via their last arg.
    #       Don't forget to allocate a MemoryPointer for the result if using it.
    attach_function :Vix_ReleaseHandle, [:VixHandle], :void
    attach_function :Vix_AddRefHandle, [:VixHandle], :void
    attach_function :Vix_GetHandleType, [:VixHandle], :VixHandleType
    attach_function :Vix_GetProperties, [:VixHandle, :VixPropertyID, :varargs], :VixError
    attach_function :Vix_GetPropertyType, [:VixHandle, :VixPropertyID, :pointer], :VixError
    attach_function :Vix_FreeBuffer, [:pointer], :void
  
    attach_function :VixPropertyList_AllocPropertyList, [:VixHandle, 
      :VixHandle, :int, :varargs], :VixError
  
    # Event Types
  
    VixEventType = enum(
      :VIX_EVENTTYPE_JOB_COMPLETED, 2,
      :VIX_EVENTTYPE_JOB_PROGRESS, 3,
      :VIX_EVENTTYPE_FIND_ITEM, 8,
      :VIX_EVENTTYPE_CALLBACK_SIGNALLED, 2 # deprecated -- use VIX_EVENTTYPE_JOB_COMPLETED instead.
    )
    
    # Callback-related stuff
    callback :VixEventProc, [:VixHandle, VixEventType, :VixHandle, :pointer], :void
  
    enum [
      :VIX_FILE_ATTRIBUTES_DIRECTORY, 0x0001,
      :VIX_FILE_ATTRIBUTES_SYMLINK, 0x0002
    ]
    
    # VIX Host Options
  
    enum :VixHostOptions, [:VIX_HOSTOPTION_USE_EVENT_PUMP, 0x0008]
    enum :VixServiceProvider, [
      :VIX_SERVICEPROVIDER_DEFAULT, 1,
      :VIX_SERVICEPROVIDER_VMWARE_SERVER, 2,
      :VIX_SERVICEPROVIDER_VMWARE_WORKSTATION, 3,
      :VIX_SERVICEPROVIDER_VMWARE_PLAYER, 4,
      :VIX_SERVICEPROVIDER_VMWARE_VI_SERVER, 10
    ]
    enum :VixAPIVersion, [
      :VIX_API_LATEST_VERSION, -1 # connect to the latest version of the API.
    ]
  
    attach_function :VixHost_Connect, [:VixAPIVersion, :VixServiceProvider, :string, :int,
      :string, :string,  :VixHostOptions, :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixHost_Disconnect, [:VixHandle], :void
  
    # VM Registration
  
    attach_function :VixHost_RegisterVM, [:VixHandle, :string, :VixEventProc, 
      :pointer], :VixHandle
    attach_function :VixHost_UnregisterVM, [:VixHandle, :string, :VixEventProc, 
      :pointer], :VixHandle
  
    # VM Search
  
    enum :VixFindItemType, [
      :VIX_FIND_RUNNING_VMS, 1,
      :VIX_FIND_REGISTERED_VMS, 4
    ]
  
    attach_function :VixHost_FindItems, [:VixHandle, :VixFindItemType, 
      :VixHandle, :int32, :VixEventProc, :pointer], :VixHandle
  
    # Event Pump
  
    typedef :int, :VixPumpEventsOptions
    enum [:VIX_PUMPEVENTOPTION_NONE, 0]
    attach_function :Vix_PumpEvents, [:VixHandle, :VixPumpEventsOptions], :void
  
    # VM Functions
  
    enum :VixVMOpenOptions, [:VIX_VMOPEN_NORMAL, 0x0]
    attach_function :VixVM_Open, [:VixHandle, :string, :VixVMOpenOptions, 
      :VixHandle, :VixEventProc, :pointer], :VixHandle # deprecates VixVM_Open --> VixHost_OpenVM
  
    attach_function :VixVM_Open, [:VixHandle, :string, :VixEventProc, 
      :pointer], :VixHandle
  
    # Power Ops
  
    enum :VixVMPowerOpOptions, [
      :VIX_VMPOWEROP_NORMAL, 0,
      :VIX_VMPOWEROP_FROM_GUEST, 0x0004,
      :VIX_VMPOWEROP_SUPPRESS_SNAPSHOT_POWERON, 0x0080,
      :VIX_VMPOWEROP_LAUNCH_GUI, 0x0200,
      :VIX_VMPOWEROP_START_VM_PAUSED, 0x1000
    ]
  
    enum :VixPowerState, [
      :VIX_POWERSTATE_POWERING_OFF, 0x0001, 
      :VIX_POWERSTATE_POWERED_OFF, 0x0002,
      :VIX_POWERSTATE_POWERING_ON, 0x0004,
      :VIX_POWERSTATE_POWERED_ON, 0x0008,
      :VIX_POWERSTATE_SUSPENDING, 0x0010,
      :VIX_POWERSTATE_SUSPENDED, 0x0020,
      :VIX_POWERSTATE_TOOLS_RUNNING, 0x0040,
      :VIX_POWERSTATE_RESETTING, 0x0080,
      :VIX_POWERSTATE_BLOCKED_ON_MSG, 0x0100,
      :VIX_POWERSTATE_PAUSED, 0x0200,
      :VIX_POWERSTATE_RESUMING, 0x0800
    ]
  
    attach_function :VixVM_PowerOn, [:VixHandle, :VixVMPowerOpOptions, 
      :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_PowerOff, [:VixHandle, :VixVMPowerOpOptions, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_PowerOff, [:VixHandle, :VixVMPowerOpOptions, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_Suspend, [:VixHandle, :VixVMPowerOpOptions, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_Pause, [:VixHandle, :int, :VixHandle, :VixEventProc, 
      :pointer], :VixHandle
    attach_function :VixVM_Unpause, [:VixHandle, :int, :VixHandle, 
      :VixEventProc, :pointer], :VixHandle
  
    # VM Deletion
  
    typedef :int, :VixVMDeleteOptions
    enum [:VIX_VMDELETE_DISK_FILES, 0x0002]
  
    attach_function :VixVM_Delete, [:VixHandle, :VixVMDeleteOptions, 
      :VixEventProc, :pointer], :VixHandle
  
    # VMWare Tools
  
    enum :VixToolsState, [
      :VIX_TOOLSSTATE_UNKNOWN, 0x0001,
      :VIX_TOOLSSTATE_RUNNING, 0x0002,
      :VIX_TOOLSSTATE_NOT_INSTALLED, 0x0004
    ]
  
    enum [
      :VIX_VM_SUPPORT_SHARED_FOLDERS, 0x0001,
      :VIX_VM_SUPPORT_MULTIPLE_SNAPSHOTS, 0x0002,
      :VIX_VM_SUPPORT_TOOLS_INSTALL, 0x0004, 
      :VIX_VM_SUPPORT_HARDWARE_UPGRADE, 0x0008
    ]
  
    attach_function :VixVM_WaitForToolsInGuest, [:VixHandle, :int, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_InstallTools, [:VixHandle, :int, :string, 
      :VixEventProc, :pointer], :VixHandle
  
    # Record/Replay Ops
  
    attach_function :VixVM_BeginRecording, [:VixHandle, :string, :string, :int, 
      :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_EndRecording, [:VixHandle, :int, :VixHandle, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_BeginReplay, [:VixHandle, :VixHandle, :int, 
      :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_EndReplay, [:VixHandle, :int, :VixHandle, 
      :VixEventProc, :pointer], :VixHandle
  
    # Guest Login/Out Ops
  
    enum [:VIX_LOGIN_IN_GUEST_REQUIRE_INTERACTIVE_ENVIRONMENT, 0x08]
  
    attach_function :VixVM_LoginInGuest, [:VixHandle, :string, :string, :int, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_LogoutFromGuest, [:VixHandle, :VixEventProc, 
      :pointer], :VixHandle
  
    # Guest Process Control
  
    enum :VixRunProgramOptions, [
      :VIX_RUNPROGRAM_RETURN_IMMEDIATELY, 0x0001,
      :VIX_RUNPROGRAM_ACTIVATE_WINDOW, 0x0002
    ]
  
    attach_function :VixVM_RunProgramInGuest, [:VixHandle, :string, :string, 
      :VixRunProgramOptions, :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_ListProcessesInGuest, [:VixHandle, :int, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_KillProcessInGuest, [:VixHandle, :uint64, :int, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_RunScriptInGuest, [:VixHandle, :string, :string, 
      :VixRunProgramOptions, :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_OpenUrlInGuest, [:VixHandle, :string, :int, 
      :VixHandle, :VixEventProc, :pointer], :VixHandle
  
    # Guest Filesystem Functions
  
    attach_function :VixVM_CopyFileFromHostToGuest, [:VixHandle, :string, 
      :string, :int, :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_CopyFileFromGuestToHost, [:VixHandle, :string, 
      :string, :int, :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_DeleteFileInGuest, [:VixHandle, :string, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_FileExistsInGuest, [:VixHandle, :string, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_RenameFileInGuest, [:VixHandle, :string, :string, 
      :int, :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_CreateTempFileInGuest, [:VixHandle, :int, 
      :VixHandle, :VixEventProc, :pointer], :VixHandle
  
    attach_function :VixVM_ListDirectoryInGuest, [:VixHandle, :string, :int, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_CreateDirectoryInGuest, [:VixHandle, :string, 
      :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_DeleteDirectoryInGuest, [:VixHandle, :string, :int, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_DirectoryExistsInGuest, [:VixHandle, :string, 
      :VixEventProc, :pointer], :VixHandle
    
    # Guest Var Functions
  
    enum [
      :VIX_VM_GUEST_VARIABLE, 1,
      :VIX_VM_CONFIG_RUNTIME_ONLY, 2,
      :VIX_GUEST_ENVIRONMENT_ONLY, 3
    ]
  
    attach_function :VixVM_ReadVariable, [:VixHandle, :int, :string, :int, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_WriteVariable, [:VixHandle, :int, :string, :string, 
      :int, :VixEventProc, :pointer], :VixHandle
  
    # Snapshot Functions
  
    enum :VixRemoveSnapshotOptions, [:VIX_SNAPSHOT_REMOVE_CHILDREN, 0x0001]
    enum :VixCreateSnapshotOptions, [:VIX_SNAPSHOT_INCLUDE_MEMORY, 0x0002]
  
    attach_function :VixVM_GetNumRootSnapshots, [:VixHandle, :pointer], :VixError
    attach_function :VixVM_GetRootSnapshot, [:VixHandle, :int, :pointer], :VixError
    attach_function :VixVM_GetCurrentSnapshot, [:VixHandle,  :pointer], :VixError
    attach_function :VixVM_GetNamedSnapshot, [:VixHandle, :string, :pointer], :VixError
    attach_function :VixVM_RemoveSnapshot, [:VixHandle, :VixHandle, 
      :VixRemoveSnapshotOptions, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_RevertToSnapshot, [:VixHandle, :VixHandle, 
      :VixVMPowerOpOptions, :VixHandle, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_CreateSnapshot, [:VixHandle, :string, :string, 
      :VixCreateSnapshotOptions, :VixHandle, :VixEventProc, :pointer], :VixHandle
  
    attach_function :VixSnapshot_GetNumChildren, [:VixHandle, :pointer], :VixError
    attach_function :VixSnapshot_GetChild, [:VixHandle, :int, :pointer], :VixError
    attach_function :VixSnapshot_GetParent, [:VixHandle, :pointer], :VixError
  
    # Shared-Folder Functions
  
    enum :VixMsgSharedFolderOptions, [:VIX_SHAREDFOLDER_WRITE_ACCESS, 0x04]
  
    attach_function :VixVM_EnableSharedFolders, [:VixHandle, :bool, :int, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_GetNumSharedFolders, [:VixHandle, :VixEventProc, 
      :pointer], :VixHandle
    attach_function :VixVM_GetSharedFolderState, [:VixHandle, :int, 
      :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_SetSharedFolderState, [:VixHandle, :string, :string, 
      :VixMsgSharedFolderOptions, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_AddSharedFolder, [:VixHandle, :string, :string, 
      :VixMsgSharedFolderOptions, :VixEventProc, :pointer], :VixHandle
    attach_function :VixVM_RemoveSharedFolder, [:VixHandle, :string, :int, 
      :VixEventProc, :pointer], :VixHandle
  
    # Screen Capture
  
    enum [
      :VIX_CAPTURESCREENFORMAT_PNG, 0x01,
      :VIX_CAPTURESCREENFORMAT_PNG_NOCOMPRESS, 0x02
    ]
  
    attach_function :VixVM_CaptureScreenImage, [:VixHandle, :int, :VixHandle, 
      :VixEventProc, :pointer], :VixHandle
  
    # Cloning
  
    enum :VixCloneType, [
      :VIX_CLONETYPE_FULL, 0,
      :VIX_CLONETYPE_LINKED, 1
    ]
  
    attach_function :VixVM_Clone, [:VixHandle, :VixHandle, :VixCloneType, 
      :string, :int, :VixHandle, :VixEventProc, :pointer], :VixHandle
  
    # Misc Utils
  
    enum [
      :VIX_INSTALLTOOLS_MOUNT_TOOLS_INSTALLER, 0x00,
      :VIX_INSTALLTOOLS_AUTO_UPGRADE, 0x01, 
      :VIX_INSTALLTOOLS_RETURN_IMMEDIATELY, 0x02
    ]
  
    attach_function :VixVM_UpgradeVirtualHardware, [:VixHandle, :int, 
      :VixEventProc, :pointer], :VixHandle
  
    # Job Functions
  
    attach_function :VixJob_Wait, [:VixHandle, :VixPropertyID, :varargs], :VixError
    attach_function :VixJob_CheckCompletion, [:VixHandle, :bool], :VixError
  
    attach_function :VixJob_GetError, [:VixHandle], :VixError
    attach_function :VixJob_GetNumProperties, [:VixHandle, :int], :VixError
    attach_function :VixJob_GetNthProperties, [:VixHandle, :int, :int, :varargs], :VixError
  
    
    # The VMwareException class can be thrown whenever a VIX function returns 
    # anything other than 0 (success), and should be provided the function's 
    # return value upon instantiation. It will use the VIX api to convert 
    # the error code to text.
    
    class VMWareException < RuntimeError

      @@locale = 'en-us' # default locale
      attr_reader :error_type, :error_id

      def self.locale=(locale_id)
        raise TypeError unless locale_id.respond_to? 'to_s'
        @@locale = locale_id || 'en-us'
      end

      def initialize(error_id)
        @error_id = error_id
      end

      def to_s
        VIX::Vix_GetErrorText(@error_id, @@locale)
      end

    end
    
    class Handle

      @@handles = {}

      class <<self
        
        # Get an existing handle by id.
        def from_id(id)
          @@handles[id] || nil
        end
        
        # Get an existing handle by pointer.
        def from_ptr(ptr)
          @@handles[ptr.get_int(0)] || nil
        end
        
        # Return bool indicating if handle exists.
        def exists?(handle_id)
          @@handles.has_key? handle_id
        end
        
        def clear_all!
          @@handles = {}
        end
        
      end
      
      attr_accessor :prev_handle_id
      
      # Return the handle ID.
      def id
        ptr.get_int(0)
      end
      
      # Return the handle pointer.
      def ptr
        @handle_ptr ||= FFI::MemoryPointer.new(:int)
      end
      
      # Set the handle_id.
      # TODO: Change this to deal with 0 ids automatically.
      def id=(new_id)
        raise IndexError.new 'handle_id already exists.' if Handle.exists? new_id
        unless Handle.exists? new_id
          @@handles[new_id] = self
          @@handles.delete @prev_handle_id
        end
        ptr.write_int(new_id)
        @prev_handle_id = new_id
      end

      def ptr=(new_ptr)
        new_id = new_ptr.get_int(0)
        raise 'handle_id already exists.' if Handle.exists? new_id
        unless Handle.exists? new_id
          @@handles[new_id] = self
          @@handles.delete @prev_handle_id
        end
        @handle_ptr = ptr
        @prev_handle_id = new_id
      end
      
      def ptr_updated!
        ptr = ptr
      end

      def release
        
      end
      
      def valid?
        !!(!id.eql? 0)
      end
      
      def [](key)
        raise 'Invalid handle instance.' unless valid?
        prop_type = property_type(key)
        result_ptr = FFI::MemoryPointer.new(prop_type.to_sym)
        VMWare.vix_attempt VIX::Vix_GetProperties(id, key, 
          :pointer, result_ptr, :VixPropertyID, :VIX_PROPERTY_NONE
        )
        return result_ptr.send :"get_#{prop_type.to_s}", 0
      end

      def property(*args)
        raise 'Invalid handle instance.' unless valid?
        results = []
        props = args.collect do |key|
          prop_type = property_type(key)
          ptr = FFI::MemoryPointer.new(prop_type)
          results << [prop_type, ptr]
          [:VixPropertyID, key, :pointer, ptr]
        end
        VMWare.vix_attempt VIX::Vix_GetProperties(id, *props[0][1..props[0].length], 
          *props[0..props.length].flatten!, :VixPropertyID, :VIX_PROPERTY_NONE
        )
        results.collect! { |result| result[1].send :"get_#{result[0]}", 0 }
      end

      def property_type(property_id)
        raise 'Invalid handle instance.' unless valid?
        prop_type_ptr = FFI::MemoryPointer.new(:int)
        VMWare.vix_attempt VIX::Vix_GetPropertyType(id, property_id, prop_type_ptr)
        VIX::VixPropertyType[prop_type_ptr.get_int(0)]
      end

      def handle_type
        raise 'Invalid handle instance.' unless valid?
        VIX::Vix_GetHandleType(id)
      end

    end
    
  end # VIX module
  
  
  # Validate a result from a VIX function, throwing a new VMWareException 
  # if an error occurs. Optionally accepts a block -- however, the block 
  # must return the error ID.
  def self.vix_attempt(result, &block)
   result = block.call unless result
   raise VIX::VMWareException.new(result.to_i) unless result == 0
   return result
  end
  
  # The JobHandle class abstracts the job interface from VIX to Ruby. It 
  # supports simple task definition using blocks, and an event-based model 
  # relying upon callbacks.
  class Job < VIX::Handle
        
    HUMAN_EVENT_MAPPING = {
      :VIX_EVENTTYPE_JOB_COMPLETED => :complete,
      :VIX_EVENTTYPE_CALLBACK_SIGNALLED => :complete, # deprecated
      :VIX_EVENTTYPE_JOB_PROGRESS => :progress,
      :VIX_EVENTTYPE_FIND_ITEM => :item_found,
      :VIX_EVENTTYPE_HOST_INITIALIZED => :host_initialized
    }

    # Handle _all_ callbacks for a given job, notifying the singleton 
    # instance when an event has been fired. Assigned as a const to 
    # prevent segfault caused by Proc going out of scope caused by GC.
    EVENT_CALLBACK = Proc.new do |*args|
      Job.from_id(args[0]).trigger_event(*args)
    end

    attr_accessor :context
    attr_accessor :event_threads

    # Initialize a new JobHandle instance, optionally given a block to 
    # perform by calling the instance's begin method.
    def initialize(opts = {}, &task)
      raise 'No task defined' unless block_given?
      @task = task
      @context = opts[:context] || {}
      @event_handlers = opts[:event_handlers] || {}
      @event_threads = []
    end

    def event_callback
      EVENT_CALLBACK
    end
    
    # Responds to an event being fired, and calls the appropriate 
    # user-registered event handler. Events are typically fired by a VIX 
    # callback, dispatched to the proper job instance by EVENT_CALLBACK proc.
    # todo: Move this to a thread-pool model.
    def trigger_event(job_handle, evt_type, evt_info, client_ctx)
      event_name = Job::HUMAN_EVENT_MAPPING[evt_type]
      return unless @event_handlers.has_key? event_name
      @event_threads << Thread.new(event_name, self, evt_info) do |evt_n, job, evt_d|
        @event_handlers[evt_n].call(job, job.context, evt_d)
      end
    end

    # Execute the job and continue.
    def start
      self.id = @task.call(self, context)
      return self
    end

    # Execute job (if necessary) and block until job is complete.
    def join!
      raise 'No join handler defined for job.' unless @event_handlers.has_key? :join
      @event_handlers[:join].call(self, context)
    end
    
    # Setup a handler for an asynchronous job status change. Accepts a 
    # block to perform when the status has changed to match event_name.
    def on(event_name, opts = nil, &block)
      @event_handlers[event_name] = block
    end
    
    def join(&block)
      raise 'No block given to describe how to join!' unless block_given?
      @event_handlers[:join] = block
    end
    
    # TODO: Fix so that block works.
    def properties(property_id, get_props = [], &block)
      set_results = []
      VIX::VixJob_GetNumProperties(id, property_id).times do |prop_index|
        results = []
        props = get_props.collect do |key|
          prop_type = property_type(key)
          ptr = FFI::MemoryPointer.new(prop_type)
          results << [prop_type, ptr]
          [:VixPropertyID, key, :pointer, ptr]
        end
        VMWare.vix_attempt VIX::VixJob_GetNthProperties(self.id, prop_index, 
          *props[0][1..props[0].length], 
          *props[1..props.length].flatten!, 
          :VixPropertyID, :VIX_PROPERTY_NONE
        )
        results.collect! { |result| result[1].send :"get_#{result[0]}", 0 }
        set_results << Hash[*get_props.zip(results).flatten]
        yield if block_given?
      end
      return set_results
    end
    
  end
  
  
  class Host < VIX::Handle
    
    HOST_TYPES = {
      :default => :VIX_SERVICEPROVIDER_DEFAULT,
      :server => :VIX_SERVICEPROVIDER_VMWARE_SERVER, # for VMWare Server 1.0.x hosts.
      :workstation => :VIX_SERVICEPROVIDER_VMWARE_WORKSTATION,
      :player => :VIX_SERVICEPROVIDER_VMWARE_PLAYER,
      :vi_server => :VIX_SERVICEPROVIDER_VMWARE_VI_SERVER # for vCenter, ESX, ESXi, Server 2.0 hosts.
    }
    
    DEFAULT_OPTS = {
      :host_type => :vi_server,
      :hostname => nil, # defaults to localhost
      :username => nil,
      :password => nil,
      :port => 0, # will be ignored by ESX/ESXi, VMWare server
      :options => 0
    }
    
    def initialize(opts)
      @opts = DEFAULT_OPTS.clone.merge!(opts) # todo: Uhh.. handle this appropriately?!
    end
    
    # Connect to the specified host, optionally providing a block to be 
    # executed upon completion.
    def connect(&closure)
      ctx = {:host => self, :closure => closure || nil}
      
      conn_job = Job.new :context => ctx do |job, context|
        callback = context[:closure].nil? ? nil : job.event_callback
        VIX::VixHost_Connect(:VIX_API_LATEST_VERSION, 
          HOST_TYPES[@opts[:host_type]], @opts[:hostname], @opts[:port], 
          @opts[:username], @opts[:password], 0, :VIX_INVALID_HANDLE, 
          callback, nil
        )
      end

      conn_job.on :complete do |job, context, event|
        err_code, result = job.properties(
          :VIX_PROPERTY_JOB_RESULT_ERROR_CODE, 
          :VIX_PROPERTY_JOB_RESULT_HANDLE
        )
        VMWare.vix_attempt err_code
        context[:host].id = result
        context[:closure].call(context[:host])
      end
      
      conn_job.join do |job, context|
        VMWare.vix_attempt VIX::VixJob_Wait(job.id, 
          :VIX_PROPERTY_JOB_RESULT_HANDLE, 
          :pointer, context[:host].ptr, 
          :VixPropertyID, :VIX_PROPERTY_NONE
        )
        context[:host].ptr_updated!
      end
      
      conn_job.start
      conn_job.join! unless block_given?
      return conn_job
    end
    
    # Get the list of items in the host's inventory.
    def inventory(running_only = false, timeout = -1)
      discovery_type = running_only ? :VIX_FIND_RUNNING_VMS : :VIX_FIND_REGISTERED_VMS
      ctx = {:results => [], :host => self}
      
      discover = Job.new :context => ctx do |job, context|
        VIX::VixHost_FindItems(self.id, discovery_type, 
          :VIX_INVALID_HANDLE, timeout, nil, nil
        )
      end
      
      discover.join do |job, context|
        VMWare.vix_attempt VIX::VixJob_Wait(job.id, :VIX_PROPERTY_NONE)
        props = job.properties(
          :VIX_PROPERTY_FOUND_ITEM_LOCATION, 
          [:VIX_PROPERTY_FOUND_ITEM_LOCATION]
        )
        props.each do |prop|
          context[:results] << prop[:VIX_PROPERTY_FOUND_ITEM_LOCATION].read_string_to_null
        end
      end

      discover.start.join!
      return ctx[:results]
    end
    
    def register(vm_path, &closure)
      ctx = {:host => self, :vm_path => vm_path, :closure => closure}
      
      register_job = Job.new :context => ctx do |job, context|
        callback = context[:closure].nil? ? nil : job.event_callback
        VIX::VixHost_RegisterVM(self.id, context[:vm_path], callback, nil)
      end

      register_job.on :complete do |job, context|
        context[:closure].call(self, job) unless context[:closure].nil?
      end

      register_job.join do |job, context, event|
        VMWare.vix_attempt VIX::VixJob_Wait(job.handle_id, :VIX_PROPERTY_NONE)
      end

      register_job.start
      register_job.join! unless block_given?
    end
    
    def disconnect
      VIX::VixHost_Disconnect(id) # released handle here!
      release
    end
    
  end
  
  

end # module