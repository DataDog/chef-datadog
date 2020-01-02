require 'rake'
require 'chef'
require 'chef/cookbook_uploader'
require 'chef/cookbook_site_streaming_uploader'
require 'chef/knife'
require 'chef/knife/supermarket_share'

COOKBOOK_PATH = File.join(File.dirname(__FILE__), '..').freeze
METADATA_PATH = File.join(COOKBOOK_PATH, 'metadata.rb').freeze
SUPERMARKET_URL = 'https://supermarket.chef.io'.freeze

def load_metadata
  Chef::Cookbook::Metadata.new.tap do |metadata|
    metadata.from_file(METADATA_PATH)
  end
end

def clone_in_tmp_dir
  Dir.mktmpdir do |folder|
    dest_path = File.join(folder, 'cookbook')
    unless system('git', 'clone', COOKBOOK_PATH, dest_path)
      raise "Couldn't clone project into `#{dest_path}`"
    end

    yield folder
  end
end

desc 'Release the cookbook on the Chef supermarket'
task :release, :key_path do
  Chef::Knife.new.configure_chef
  metadata = load_metadata

  clone_in_tmp_dir do |cookbook_path|
    publisher = Chef::Knife::SupermarketShare.new
    publisher.config[:cookbook_path] = cookbook_path
    publisher.config[:supermarket_site] = SUPERMARKET_URL
    publisher.name_args = [metadata.name, metadata.category || 'Other']
    publisher.run
  end
end
