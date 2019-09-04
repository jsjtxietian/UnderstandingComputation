require File.join(__FILE__, '../big-stepSemantics.rb')

class Number
    def to_ruby
        "-> e { #{value.inspect} }"
    end
end

class Boolean
    def to_ruby
        "-> e { #{value.inspect} }"
    end 
end

class Variable
    def to_ruby
        "-> e { e[#{name.inspect}]}"
    end
end

class Add
    def to_ruby
        "-> e { (#{left.to_ruby}).call(e) +  (#{right.to_ruby}).call(e)}"
    end
end 

class Multiply
    def to_ruby
        "-> e { (#{left.to_ruby}).call(e) *  (#{right.to_ruby}).call(e)}"
    end
end 

class LessThan
    def to_ruby
        "-> e { (#{left.to_ruby}).call(e) <  (#{right.to_ruby}).call(e)}"
    end
end 

class Assign
    def to_ruby
        "-> e { e.merge({ #{name.inspect} => #{exp.to_ruby}.call(e)}) }"
    end
end

class If
    def to_ruby
        "-> e { if (#{cond.to_ruby}).call(e) " +
        "then (#{seq.to_ruby}).call(e)" +
        "else (#{alt.to_ruby}).call(e)"
        "end }"
    end
end

class DoNothing
    def to_ruby
        "-> e { e }"
    end
end



environment = { x: 3 }
statement = Assign.new(:y, Add.new(Variable.new(:x), Number.new(1)))
proc = eval(statement.to_ruby)
puts proc.call(environment)