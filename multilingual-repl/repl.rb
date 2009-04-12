load_assembly 'Microsoft.Scripting'
Hosting = Microsoft::Scripting::Hosting
Scripting = Microsoft::Scripting

class REPL
  def initialize
    @engine = IronRuby.create_engine
    @scope = @engine.create_scope
    @exception_service = @engine.method(:get_service).of(Hosting::ExceptionOperations).call
    @language = "rb"
  end

  def run
    while true  
      print "#@language> "
      line = gets
      break if line.nil?

      if line[0] == ?#
        execute_command line[1..-1].rstrip 
      else
        execute_code read_code(line)
      end
    end
  end
  
  # Reads lines from standard input until a complete or invalid code snippet is entered.
  # Returns ScriptSource that represents an interactive code.
  def read_code first_line
    code = first_line
    while true
      interactive_code = @engine.create_script_source_from_string(code, Scripting::SourceCodeKind.InteractiveCode)
      case interactive_code.get_code_properties
        when Scripting::ScriptCodeParseResult.Complete, Scripting::ScriptCodeParseResult.Invalid:
          return interactive_code
                    
        else
          print "#@language| "
          next_line = gets
          return interactive_code if next_line.nil? or next_line.strip.size == 0 
          code += next_line
      end      
    end
  end

  # Executes given ScriptSource and prints any exceptions that it might raise.
  def execute_code source
    source.execute(@scope)
  rescue Exception => e
    message, name = @exception_service.get_exception_message(e)
    puts "#{name}: #{message}"
  end

  def execute_command command
    case command
      when 'exit': exit
      when 'ls?': display_languages
      else puts "Unknown command '#{command}'" unless switch_language command
    end
  end

  def display_languages
    @engine.runtime.setup.language_setups.each { |ls| puts "#{ls.display_name}: #{ls.names.inspect}" }
  end

  def switch_language name
    has_engine, engine = @engine.runtime.try_get_engine(name)
    @language, @engine = name, engine if has_engine
    has_engine
  end
end

REPL.new.run