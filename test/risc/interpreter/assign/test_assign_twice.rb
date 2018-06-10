require_relative "../helper"

module Risc
  class InterpreterAssignTwice < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("a = 5 ;a = 5 + a ; return a")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, SlotToReg, RegToSlot, LoadConstant, LoadConstant,
             SlotToReg, RegToSlot, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, Branch, RegToSlot,
             SlotToReg, RegToSlot, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, Branch, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, FunctionCall, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, OperatorInstruction, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, RegToSlot, RegToSlot,
             SlotToReg, Branch, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, SlotToReg, FunctionReturn, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, Branch, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, FunctionReturn, Transfer, Syscall, NilClass]
      assert_equal 10 , get_return.value
    end
  end
end