require_relative "../helper"

module Risc
  class InterpreterWhileCmp < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'a = 0; while( 0 >= a); a = 1 + a;end;return a'
      super
    end

    def test_if
        #show_main_ticks # get output of what is in main
        check_main_chain [LoadConstant, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, LoadConstant, SlotToReg,
             RegToSlot, RegToSlot, SlotToReg, Branch, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             RegToSlot, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, Branch, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             SlotToReg, FunctionCall, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, OperatorInstruction, IsMinus, LoadConstant,
             Branch, RegToSlot, SlotToReg, SlotToReg, Branch,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, FunctionReturn,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, Branch,
             SlotToReg, LoadConstant, OperatorInstruction, IsZero, LoadConstant,
             OperatorInstruction, IsZero, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, LoadConstant, Branch, SlotToReg,
             RegToSlot, RegToSlot, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, RegToSlot,
             SlotToReg, RegToSlot, Branch, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, SlotToReg,
             FunctionCall, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, OperatorInstruction, LoadConstant, SlotToReg, SlotToReg,
             RegToSlot, RegToSlot, RegToSlot, SlotToReg, Branch,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             FunctionReturn, SlotToReg, SlotToReg, RegToSlot, Branch,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             LoadConstant, SlotToReg, RegToSlot, RegToSlot, SlotToReg,
             Branch, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, RegToSlot, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, Branch,
             SlotToReg, SlotToReg, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, FunctionCall, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, OperatorInstruction,
             IsMinus, LoadConstant, RegToSlot, SlotToReg, SlotToReg,
             Branch, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             FunctionReturn, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             Branch, SlotToReg, LoadConstant, OperatorInstruction, IsZero,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, SlotToReg, Branch,
             FunctionReturn, Transfer, SlotToReg, Branch, SlotToReg,
             Syscall, NilClass]
       assert_equal 1 , get_return
    end
    def test_exit
      done = main_ticks(201)
      assert_equal Syscall ,  done.class
    end
  end
end
