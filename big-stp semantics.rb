require File.join(__FILE__, '../small-step semantics.rb')


class Number 
    def evaluate(env)
        self
    end 
end 

class Boolean
    def evaluate(env)
        self
    end 
end 

class Variable 
    def evaluate(env)
        env[name]
    end
end

class Add 
    def evaluate(env)
        Number.new(left.evaluate(env).value + right.evaluate(env).value)
    end 
end 

class Multiply 
    def evaluate(env)
        Number.new(left.evaluate(env).value * left.evaluate(env).value)
    end 
end 

class LessThan 
    def evaluate(env)
        Boolean.new(left.evaluate(env).value < right.evaluate(env).value)
    end 
end 


class Assign 
    def evaluate(env)
        env.merge({name => exp.evaluate(env)})
    end 
end 

class DoNothing 
    def evaluate(environment) 
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
            evaluate(body.evaluate(env))
        when Boolean.new(false)
            env
        end
    end
end 

statement = While.new(
    LessThan.new(Variable.new(:x), Number.new(5)), Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3))))

puts statement.evaluate({x:Number.new(1)})

