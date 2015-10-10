module Phisol
  Compiler.class_eval do

    def on_while_statement statement
      #puts statement.inspect
      condition , statements = *statement
      condition = condition.first

      # this is where the while ends and both branches meet
      merge = @method.source.new_block("while merge")
      # this comes after the current and beofre the merge
      start = @method.source.new_block("while_start" )
      @method.source.current start

      cond = process(condition)

      @method.source.add_code Register::IsZeroBranch.new(condition,merge)

      last = process_all(statements).last

      # unconditionally branch to the start
      @method.source.add_code Register::AlwaysBranch.new(statement,start)

      # continue execution / compiling at the merge block
      @method.source.current merge
      last
    end
  end
end