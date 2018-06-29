module Risc
  module Builtin
    class Object
      module ClassMethods
        include CompileHelper

        # self[index] basically. Index is the first arg
        # return is stored in return_value
        # (this method returns a new method off course, like all builtin)
        def get_internal_word( context )
          compiler = compiler_for(:Object , :get_internal_word ,{at: :Integer})
          builder = compiler.compiler_builder(compiler.method)
          source = "get_internal_word"
          me , index = builder.self_and_int_arg(source)
          # reduce me to me[index]
          builder.add_slot_to_reg( source , me , index , me)
          # and put it back into the return value
          builder.add_reg_to_slot( source , me , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg , value the second
        # no return
        def set_internal_word( context )
          compiler = compiler_for(:Object , :set_internal_word , {at: :Integer, :value => :Object} )
          source = "set_internal_word"
          builder = compiler.compiler_builder(compiler.method)
          me , index = builder.self_and_int_arg(source)
          value = builder.load_int_arg_at(source , 1)
          # do the set
          builder.add_reg_to_slot( source , value , me , index)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end

        # every object needs a method missing.
        # Even if it's just this one, sys_exit (later raise)
        def _method_missing( context )
          compiler = compiler_for(:Object,:method_missing ,{})
          emit_syscall( compiler.compiler_builder(compiler.method) , :exit )
          return compiler.method
        end

        # this is the really really first place the machine starts (apart from the jump here)
        # it isn't really a function, ie it is jumped to (not called), exits and may not return
        # so it is responsible for initial setup
        def __init__ context
          compiler = RiscCompiler.compiler_for_class(:Object,:__init__ ,
                            Parfait::NamedList.type_for({}) , Parfait::NamedList.type_for({}))
          builder = compiler.compiler_builder(compiler.method)
          builder.build do
            space << Parfait.object_space
            message << space[:first_message]
            next_message << message[:next_message]
            space[:first_message] << next_message
          end

          Mom::MessageSetup.new(Parfait.object_space.get_main).build_with( builder )

          builder.build do
            message << message[:next_message]
            message[:receiver] << space
          end

          exit_label = Risc.label(compiler.method , "#{compiler.method.for_type.object_class.name}.#{compiler.method.name}" )
          ret_tmp = compiler.use_reg(:Label)
          builder.build do
            add_load_constant("__init__ load return", exit_label , ret_tmp)
            add_reg_to_slot("__init__ store return", ret_tmp , :message , :return_address)
            add_function_call( "__init__ issue call" ,  Parfait.object_space.get_main)
            add_code exit_label
          end
          compiler.reset_regs
          exit_sequence(builder)
          return compiler.method
        end

        # a sort of inline version of exit method.
        # Used by exit and __init__ (so it doesn't have to call it)
        def exit_sequence(builder)
          save_message( builder )
          builder.add_slot_to_reg "get return" , :message , :return_value , :message
          builder.reduce_int( "reduce return" , :message)
          builder.add_code Syscall.new("emit_syscall(exit)", :exit )
        end

        def exit( context )
          compiler = compiler_for(:Object,:exit ,{})
          builder = compiler.compiler_builder(compiler.method)
          exit_sequence(builder)
          return compiler.method
        end

        def emit_syscall( builder , name )
          save_message( builder )
          builder.add_code Syscall.new("emit_syscall(#{name})", name )
          restore_message(builder)
          return unless (@clazz and @method)
          builder.add_code Risc.label( "#{@clazz.name}.#{@message.name}" , "return_syscall" )
        end

        # save the current message, as the syscall destroys all context
        #
        # This relies on linux to save and restore all registers
        #
        def save_message(builder)
          r8 = RegisterValue.new( :r8 , :Message)
          builder.add_code Risc.transfer("save_message", Risc.message_reg , r8 )
        end

        def restore_message(builder)
          r8 = RegisterValue.new( :r8 , :Message)
          return_tmp = builder.compiler.use_reg :fixnum
          source = "_restore_message"
          # get the sys return out of the way
          builder.add_code Risc.transfer(source, Risc.message_reg , return_tmp )
          # load the stored message into the base register
          builder.add_code Risc.transfer(source, r8 , Risc.message_reg )
          int = builder.compiler.use_reg(:Integer)
          builder.add_new_int(source , return_tmp , int )
          # save the return value into the message
          builder.add_code Risc.reg_to_slot( source , int , :message , :return_value )
        end

      end
      extend ClassMethods
    end
  end
end
