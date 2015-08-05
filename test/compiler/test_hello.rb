require_relative "compiler_helper"

class HelloTest < MiniTest::Test

  def check
    machine = Virtual.machine.boot
    expressions = machine.compile_main @string_input
    output_at = "Register::CallImplementation"
    #{}"Register::CallImplementation"
    machine.run_before output_at
    #puts Sof.write(machine.space)
    machine.run_after output_at
    writer = Elf::ObjectWriter.new(machine)
    writer.save "hello.o"
  end

  def qtest_simplest_function
    @string_input    = <<HERE
def foo(x)
  5
end
HERE
    check
  end

  def ttest_puts_string
    @string_input    = <<HERE
putstring("Hello")
HERE
    check
  end

  def test_string_put
    @string_input    = <<HERE
"Hello again\n".putstring()
HERE
    check
  end
end