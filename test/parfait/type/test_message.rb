require_relative "../helper"

module Parfait
  class TypeMessages < ParfaitTest

    def setup
      super
      @mess = @space.get_next_for(:Message)
    end

    def test_message_type
      type = @mess.get_type
      assert type
      assert @mess.instance_variable_defined :next_message
      assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
    end

    def test_message_by_index
      assert_equal @mess.next_message , @mess.get_instance_variable(:next_message)
      index = @mess.get_type.variable_index :next_message
      assert_equal 1 , index
      assert_equal @mess.next_message , @mess.get_internal_word(index)
    end

    def test_type_methods
      assert  @mess.get_type#.get_type.variable_index(:methods)
      assert_equal 4 , @mess.get_type.get_type.variable_index(:methods)
    end

    def test_mess_class
      mess = @space.get_class_by_name(:Message)
      assert_equal :Message , mess.name
      mess_type = @space.get_type_by_class_name(:Message)
      assert mess_type.get_type , "No type, but no raise either"
    end
  end
end
