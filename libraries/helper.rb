#
# Cookbook Name:: datadog
# Library:: helper
#
# Author:: Justin Schuhmann <jmschu02@gmail.com>
#

if RUBY_PLATFORM =~ /mswin|mingw32|windows/
  require 'chef/win32/version'
end

#Helper to find if windows is older than 2003r2
module Datadog
  module Helper
    def self.older_than_windows2003r2?
      if RUBY_PLATFORM =~ /mswin|mingw32|windows/
        win_version = Chef::ReservedNames::Win32::Version.new
        win_version.windows_server_2003_r2? ||
        win_version.windows_home_server? ||
        win_version.windows_server_2003? ||
        win_version.windows_xp? ||
        win_version.windows_2000?
      end
    end
  end
end
