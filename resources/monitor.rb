# Configure a service via its yaml file

actions :add, :remove

def initialize(*args)
  super
  @action = :add
end
