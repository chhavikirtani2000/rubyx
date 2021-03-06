require_relative "../helper"

module Risc
  # Test the alloc sequence used by all integer operations
  class InterpreterIntAlloc < MiniTest::Test
    include Ticker

    def setup
      @preload = "Integer.plus"
      @string_input = as_main("return 5 + 5")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, SlotToReg, #5
                 RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant, #10
                 SlotToReg, RegToSlot, SlotToReg, FunctionCall, LoadConstant, #15
                 SlotToReg, LoadConstant, OperatorInstruction, IsNotZero, SlotToReg, #20
                 RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg, #25
                 OperatorInstruction, RegToSlot, RegToSlot, SlotToReg, RegToSlot, #30
                 Branch, Branch, SlotToReg, SlotToReg, RegToSlot, #35
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, SlotToReg, #40
                 RegToSlot, Branch, SlotToReg, SlotToReg, RegToSlot, #45
                 SlotToReg, SlotToReg, SlotToReg, FunctionReturn, Transfer, #50
                 SlotToReg, SlotToReg, Syscall, NilClass,] #55
       assert_equal 10 , get_return
    end
    def base_ticks(num)
      main_ticks(14 + num)
    end
    def test_base
        assert_equal FunctionCall , main_ticks( 14 ).class
    end
    def test_load_factory
      lod = base_ticks( 1 )
      assert_load( lod , Parfait::Factory , :r2)
      assert_equal :next_integer , lod.constant.attribute_name
    end
    def test_slot_receiver #load next_object from factory
      sl = base_ticks( 2 )
      assert_slot_to_reg( sl , :r2 , 2 , :r1)
    end
    def test_load_nil
      lod = base_ticks( 3 )
      assert_load( lod , Parfait::NilClass , :r3)
    end
    def test_nil_check
      op = base_ticks(4)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
      assert_equal :r3 , op.left.symbol
      assert_equal :r1 , op.right.symbol
      assert_equal ::Integer , @interpreter.get_register(:r3).class
      assert 0 != @interpreter.get_register(:r3)
    end
    def test_branch
      br = base_ticks( 5 )
      assert_equal IsNotZero , br.class
      assert br.label.name.start_with?("cont_label")
    end
    def test_load_next_int
      sl = base_ticks( 6 )
      assert_slot_to_reg( sl , :r1 , 1 , :r4)
    end
    def test_move_next_back_to_factory
      int = base_ticks( 7 )
      assert_reg_to_slot( int , :r4 , :r2 , 2)
    end
  end
end
