# Configure a service via its yaml file

actions :add, :remove
default_action :add if defined?(default_action)

attribute :name, :kind_of => String, :name_attribute => true
attribute :cookbook, :kind_of => String, :default => 'datadog'

# checks have 3 sections: init_config, instances, logs
# we mimic these here, no validation is performed until the template
# is evaluated.
attribute :init_config, :kind_of => Hash, :required => false, :default => {}
attribute :instances, :kind_of => Array, :required => false, :default => []
attribute :logs, :kind_of => Array, :required => false, :default => []
attribute :version, :kind_of => Integer, :required => false, :default => nil
attribute :use_integration_template, :kind_of => [TrueClass, FalseClass], :required => false, :default => false
