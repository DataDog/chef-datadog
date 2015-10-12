require 'chefspec'
require 'chefspec/berkshelf'
require 'coveralls'
Coveralls.wear!

require 'json_spec'
require 'yaml'

RSpec.configure do |config|
  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # run all specs when using a filter, but no spec match
  config.run_all_when_everything_filtered = true
end

ChefSpec::Coverage.start!
