module Virtual
  module Compiler
  # operators are really function calls

#    call_site - attr_reader  :name, :args , :receiver

    def self.compile_callsite expession , method
      me = Compiler.compile( expession.receiver , method )

      ## need two step process, compile and save to frame
      # then move from frame to new message
      method.source.add_code NewMessage.new
      method.source.add_code Set.new( me , NewSelf.new(me.type))
      method.source.add_code Set.new( expession.name.to_sym , NewMessageName.new())
      compiled_args = []
      expession.args.each_with_index do |arg , i|
        #compile in the running method, ie before passing control
        val = Compiler.compile( arg , method)
        # move the compiled value to it's slot in the new message
        # + 1 as this is a ruby 0-start , but 0 is the last message ivar.
        # so the next free is +1
        to = NewArgSlot.new(i + 1 ,val.type , val)
        # (doing this immediately, not after the loop, so if it's a return it won't get overwritten)
        method.source.add_code Set.new( val , to )
        compiled_args << to
      end
      method.source.add_code MessageSend.new(expession.name , me , compiled_args) #and pass control
      # the effect of the method is that the NewMessage Return slot will be filled, return it
      # (this is what is moved _inside_ above loop for such expressions that are calls (or constants))
      Return.new( method.source.return_type )
    end
  end
end
