require_relative "helper"

module SlotMachine

  class TestSlottedObjectType < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      compiler = Risc.test_compiler
      @slotted = Slotted.for(Parfait.object_space , [:type])
      register = @slotted.to_register(compiler , InstructionMock.new)
      @instruction = compiler.risc_instructions.next
    end
    def test_def_class
      assert_equal Risc::LoadConstant , @instruction.class
    end
    def test_def_register
      assert_equal :r1 , @instruction.register.symbol
    end
    def test_def_const
      assert_equal Parfait::Space , @instruction.constant.class
    end
    def test_to_s
      assert_equal "Space.type" , @slotted.to_s
    end
    def test_def_register2
      assert_equal :r1 , @instruction.next.register.symbol
    end
    def test_def_next_index
      assert_equal 0 , @instruction.next.index
    end
  end
end
