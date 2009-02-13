require 'IronRuby'
runtime = IronRuby.create_runtime

# ask the runtime for Python engine using one of its simple names:
engine = runtime.get_engine("IronPython")

scope = engine.create_scope

while true  
  print "> "
  code = gets
  break if code.nil?
  begin
    result = engine.execute(code, scope)

    # print the Ruby's view of the result:
    p result

    # print the result as Python would display it:
    puts engine.operations.format(result)
  rescue Exception
    puts $!
  end
end