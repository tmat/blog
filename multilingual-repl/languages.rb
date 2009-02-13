# load IronRuby library that provides Ruby programs an easy access to the Hosting API:
require 'IronRuby'

# create a new DLR runtime:
runtime = IronRuby.create_runtime
  
# list all available languages:
runtime.setup.language_setups.each { |ls| puts "#{ls.display_name}: #{ls.names.inspect}" }