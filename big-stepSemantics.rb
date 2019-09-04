require File.join(__FILE__, '../small-stepSemantics.rb')


class Number 
    def evaluate(env)
        puts 'Num'
        self
    end 
end 

class Boolean
    def evaluate(env)
        puts 'Bool'
        self
    end 
end 

class Variable 
    def evaluate(env)
        puts 'Var'
        env[name]
    end
end

class Add 
    def evaluate(env)
        puts 'Add'
        Number.new(left.evaluate(env).value + right.evaluate(env).value)
    end 
end 

class Multiply 
    def evaluate(env)
        puts 'Mul'
        Number.new(left.evaluate(env).value * right.evaluate(env).value)
    end 
end 

class LessThan 
    def evaluate(env)
        puts 'LessThan'
        Boolean.new(left.evaluate(env).value < right.evaluate(env).value)
    end 
end 


class Assign 
    def evaluate(env)
        puts 'Assign'
        env.merge({name => exp.evaluate(env)})
    end 
end 

class DoNothing 
    def evaluate(environment) 
        puts 'DoNothing'
        environment
    end 
end


class If 
    def evaluate(environment) 
        case condition.evaluate(environment)
        when Boolean.new(true)
            consequence.evaluate(environment) 
        when Boolean.new(false)
            alternative.evaluate(environment) 
        end 
    end 
end

class Sequence 
    def evaluate(env)
        second.evaluate(first.evaluate(env))
    end
end 

class While   
    def evaluate(env)
        case cond.evaluate(env)
        when Boolean.new(true)
            puts body.evaluate(env)
            evaluate(body.evaluate(env))
        when Boolean.new(false)
            env
        end
    end
end 


# statement = While.new(
#     LessThan.new(Variable.new(:x), Number.new(5)), 
#     Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(4)))
# )

# puts statement.evaluate({:x => Number.new(1)})

