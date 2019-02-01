# RubyVM::InstructionSequence.compile_option = { 
#     tailcall_optimization: true, 
#     trace_instruction: false
# }

class Number < Struct.new(:value)
    def to_s
        value.to_s
    end

    def inspect
        "<#{self}>"
    end

    def reducible?
        false
    end
end

class Add < Struct.new(:left,:right)
    def to_s
        "#{left} + #{right}"
    end

    def inspect
        "<#{self}>"
    end

    def reducible?
        true
    end

    def reduce (env)
        if left.reducible?
            Add.new(left.reduce(env), right)
        elsif right.reducible? 
            Add.new(left, right.reduce(env))
        else 
            Number.new(left.value + right.value) 
        end 
    end
end

class Multiply < Struct.new(:left,:right)
    def to_s
        "#{left} * #{right}"
    end

    def inspect
        "<#{self}>"
    end

    def reducible?
        true
    end

    def reduce (env)
        if left.reducible?
            Multiply.new(left.reduce(env), right)
        elsif right.reducible? 
            Multiply.new(left, right.reduce(env))
        else 
            Number.new(left.value * right.value) 
        end 
    end
end

class Boolean < Struct.new(:value)
    def to_s
        value.to_s
    end 

    def inspect
        "<#{self}>"
    end 

    def reducible? 
        false 
    end 
end

class LessThan < Struct.new(:left,:right)
    def to_s 
        "#{left} < #{right}"
    end 

    def inspect
        "<#{self}>"
    end 

    def reducible?
        true 
    end 

    def reduce (env)
        if left.reducible?
            LessThan.new(left.reduce(env),right)
        elsif right.reducible?
            LessThan.new(left,right.reduce(env))
        else 
            Boolean.new(left.value < right.value)
        end 
    end 
end 

class Variable < Struct.new(:name)
    def to_s
        name.to_s
    end

    def inspect
        "<#{self}>"
    end 

    def reducible?
        true 
    end 

    def reduce(env) 
        env[name]
    end 
end

class DoNothing
    def to_s
        'do-nothing'
    end 

    def inspect
        "<#{self}>"
    end 

    def ==(other_statement)
        other_statement.instance_of?(DoNothing)
    end 

    def reducible?
        false
    end 
end 

class Assign < Struct.new(:name , :exp)
    def to_s 
        "#{name} = #{exp}"
    end

    def inspect
        "<#{self}>"
    end 

    def reducible? 
        true
    end 

    def reduce (env)
        if exp.reducible?
            [Assign.new(name,exp.reduce(env)),env]
        else
            [DoNothing.new,env.merge({name=>exp})]
        end 
    end 
end 

class If < Struct.new(:cond , :seq , :alt)
    def to_s
        "if (#{cond}) {#{seq}} else {#{alt}}"
    end 

    def inspect
        "#{self}"
    end 

    def reducible?
        true
    end 

    def reduce(env)
        if cond.reducible?
            [If.new(cond.reduce(env),seq,alt),env]
        else 
            case cond 
            when Boolean.new(true)
                [seq,env]
            when Boolean.new(false)
                [alt,env]
            end
        end
    end 
end 

class Sequence < Struct.new(:first , :second)
    def to_s
        "#{first} ; #{second}"
    end 

    def inspect
        "#{self}"
    end 

    def reducible?
        true
    end
    
    def reduce(env)
        case first
        when DoNothing.new
            [second,env]
        else 
            reduced_first,reduced_env = first.reduce(env)
            [Sequence.new(reduced_first,second),reduced_env] 
        end         
    end 
end 

class While < Struct.new(:cond,:body)
    def to_s
        "while (#{cond}) {#{body}} "
    end 

    def inspect
        "#{self}"
    end 

    def reducible?
        true
    end

    def reduce(env)
        [If.new(
            cond,
            Sequence.new(body,self),
            DoNothing.new),
        env]
    end 
end 

class Machine < Struct.new(:st,:env)
    def step 
        self.st , self.env = st.reduce(env)
    end 

    def run 
        while st.reducible?
            puts "#{st}, #{env}"
            step 
        end
        puts "#{st}, #{env}"
    end 
end 

# Machine.new(
#     While.new(
#         LessThan.new(Variable.new(:x), Number.new(5)), 
#         Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))), 
#         { x: Number.new(1) }
# ).run