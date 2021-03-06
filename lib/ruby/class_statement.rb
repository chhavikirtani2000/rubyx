module Ruby
  class ClassStatement < Statement
    attr_reader :name, :super_class_name , :body

    # init with the class name, super class name and statement body
    # body must be Method or Send (See to_sol) or empty/nil (possibly not handled right)
    def initialize( name , supe , body)
      @name , @super_class_name = name , supe
      case body
      when MethodStatement , SendStatement
        @body = Statements.new([body])
      when Statements
        @body = body
      when nil
        @body = Statements.new([])
      else
        raise "what body #{body.class}:#{body}"
      end
    end

    # Create equivalent sol objects. Mostly for method statements
    # For calls, call transform_statement, see there
    def to_sol
      meths = []
      body.statements.each do |meth|
        if( meth.is_a?(MethodStatement))
          meths << meth.to_sol
        else
          meths += transform_statement(meth)
        end
      end
      Sol::ClassExpression.new(@name , @super_class_name, Sol::Statements.new(meths) )
    end

    # We rewrite certain send statements (so raise error for all else)
    # Currently only attributes (ie attr :name) supported, for which the standard getter
    # and setter is created and returned as sol
    def transform_statement( class_send )
      unless class_send.is_a?(SendStatement)
        raise "Other than methods, only class methods allowed, not #{class_send.class}"
      end
      allowed = [:attr , :attr_reader]
      attr_name = class_send.name
      unless allowed.include?(attr_name)
        raise "Only remapping #{allowed}, not #{attr_name}"
      end
      methods = []
      class_send.arguments.each do |attr|
        methods << getter_for(attr.value)
        methods << setter_for(attr.value) if attr_name == :attr
      end
      methods
    end

    # creates a getter method for the given instance name (sym)
    # The Method is created in Ruby, and to_sol is called to transform to Sol
    # The standard getter obviously only returns the ivar
    def getter_for(instance_name)
      return_statement = ReturnStatement.new(InstanceVariable.new(instance_name))
      MethodStatement.new(instance_name , [] , return_statement).to_sol
    end

    # creates a setter method (name=) for the given instance name (sym)
    # The Method is created in Ruby, and to_sol is called to transform to Sol
    # The setter method assigns the incoming value and returns the ivar
    def setter_for(instance_name)
      assign = IvarAssignment.new(instance_name , LocalVariable.new(:val))
      return_statement = ReturnStatement.new(InstanceVariable.new(instance_name))
      statements = Statements.new([assign, return_statement])
      MethodStatement.new("#{instance_name}=".to_sym , [:val] , statements).to_sol
    end

    def to_s(depth = 0)
      at_depth(depth , "class #{name} #{super_s}\n#{@body.to_s(depth + 1)}\nend")
    end
    # deriviation if apropriate
    def super_s
      @super_class_name ? " < #{@super_class_name}" : ""
    end
  end
end
