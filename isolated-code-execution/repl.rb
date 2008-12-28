# load IronRuby library
require 'IronRuby'

# create a new IronRuby engine and a new runtime:
engine = IronRuby.create_engine

scope = engine.create_scope

while true  
  print "> "
  code = gets
  break if code.nil?
  begin
    p engine.execute(code, scope) 
  rescue Exception
    puts $!
  end
end
