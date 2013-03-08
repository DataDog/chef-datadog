# Configure a service via its yaml file

actions :add, :remove
default_action :add if defined?(default_action)

attribute :name, :kind_of => String, :name_attribute => true
