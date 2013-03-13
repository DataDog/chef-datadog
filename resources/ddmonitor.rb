# Configure a service via its yaml file

actions :add, :remove
default_action :add if defined?(default_action)

attribute :name, :kind_of => String, :name_attribute => true
# checks have 2 sections: init_config and instances
# we mimic these here, no validation is performed until the template
# is evaluated.
attribute :init_config, :kind_of => Hash, :optional => true, :default => {}
attribute :instances, :kind_of => List, :optional => true, :default => []
