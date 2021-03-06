module SlotMachine
  class Putstring < Macro
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      builder.prepare_int_return # makes integer_tmp variable as return
      builder.build do
        word! << message[:receiver]
        integer! << word[Parfait::Word.get_length_index]
      end
      SlotMachine::Macro.emit_syscall( builder , :putstring )
      compiler
    end
  end
end
