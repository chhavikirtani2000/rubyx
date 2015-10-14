require_relative 'helper'

class TestPutint < MiniTest::Test
  include Fragments

  def test_putint
    @string_input = <<HERE
class Integer
  int putint()
    return 1
  end
end
class Object
  int main()
    42.putint()
  end
end
HERE
    @expect =  [ [Virtual::MethodEnter,Virtual::Set,Register::GetSlot,Virtual::Set,
                  Virtual::Set,Virtual::MethodCall] ,[Virtual::MethodReturn] ]
    check
  end
end
