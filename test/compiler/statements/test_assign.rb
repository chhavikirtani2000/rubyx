require_relative 'helper'

module Register
class TestAssignStatement < MiniTest::Test
  include Statements

  def setup
    Virtual.machine.boot
  end

  def test_assign_arg
    Virtual.machine.space.get_main.arguments.push Parfait::Variable.new(:Integer , :bar)
    @string_input = <<HERE
class Object
  int main(int bar)
    bar = 5
  end
end
HERE
  @expect =  [[SaveReturn,LoadConstant,SetSlot] , [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end

  def test_assign_int
    @string_input = <<HERE
class Object
  int main()
    int r = 5
  end
end
HERE
  @expect =  [[SaveReturn,LoadConstant,GetSlot,SetSlot] , [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end

  def test_assign_op
    @string_input    = <<HERE
class Object
int main()
  int n =  10 + 1
end
end
HERE
    @expect = [[SaveReturn,LoadConstant,LoadConstant,
                OperatorInstruction,GetSlot,SetSlot],[RegisterTransfer,GetSlot,FunctionReturn]]
    check
  end

  def test_assign_local
    @string_input = <<HERE
class Object
  int main()
    int runner
    runner = 5
  end
end
HERE
  @expect =  [[SaveReturn,LoadConstant,GetSlot,SetSlot] , [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end

  def test_assign_local_assign
    @string_input = <<HERE
class Object
  int main()
    int runner = 5
  end
end
HERE
    @expect =  [[SaveReturn,LoadConstant, GetSlot,SetSlot] , [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end

  def test_assign_call
    @string_input = <<HERE
class Object
  int main()
    int r = main()
  end
end
HERE
  @expect =  [[SaveReturn,GetSlot,GetSlot,SetSlot, LoadConstant,SetSlot,
                  Virtual::MethodCall,GetSlot,GetSlot,SetSlot] , [RegisterTransfer,GetSlot,FunctionReturn]]
  check
  end
end
end
