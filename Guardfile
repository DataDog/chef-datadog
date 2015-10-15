# A Guardfile
# More info at https://github.com/guard/guard#readme

guard 'foodcritic', cookbook_paths: '.' do
  watch(/attributes\/.+\.rb/)
  watch(/providers\/.+\.rb/)
  watch(/recipes\/.+\.rb/)
  watch(/resources\/.+\.rb/)
  watch(/templates\/.+/)
  watch('metadata.rb')
end

guard :rspec, cmd: 'bundle exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Chef files
  watch(/attributes\/.+\.rb/)
  watch(/providers\/.+\.rb/)
  watch(/recipes\/.+\.rb/)
  watch(/resources\/.+\.rb/)
  watch(/templates\/.+/)
  watch('metadata.rb')
end
