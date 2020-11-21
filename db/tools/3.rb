class Op
  attr_accessor :op, :val
  def initialize(op, val)
    @op = op
    @val = val
  end
end

class Tape
  def initialize
    @tape = []
    @pos = 0
  end

  def get
    @tape[@pos]
  end

  def inc(x)
    @tape[@pos] += x
  end

  def move(x)
    @pos += x
    while (@pos >= @tape.size)
      @tape << 0
    end
  end
end

class Program
  def initialize(code)
    @ops = parse code.chars.each
  end

  def run
    _run @ops, Tape.new
  end

  private

  def _run(program, tape)
    program.each do |op|
      case op.op
        when :inc; tape.inc(op.val)
        when :move; tape.move(op.val)
        when :loop; _run(op.val, tape) while tape.get > 0
        when :print; puts(tape.get.chr)
      end
    end
  end

  def parse(iterator)
    res = []
    while c = iterator.next rescue nil
      op = case c
             when '+'; Op.new(:inc, 1)
             when '-'; Op.new(:inc, -1)
             when '>'; Op.new(:move, 1)
             when '<'; Op.new(:move, -1)
             when '.'; Op.new(:print, 0)
             when '['; Op.new(:loop, parse(iterator))
             when ']'; break
           end
      res.push op if op
    end
    res
  end
end
t = Time.now
Program.new(File.read('words.txt')).run

puts "Время #{(Time.now - t)*1000}"