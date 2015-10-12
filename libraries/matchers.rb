if defined?(ChefSpec)
  def add_datadog_monitor(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:datadog_monitor, :add, resource_name)
  end

  def remove_datadog_monitor(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:datadog_monitor, :remove, resource_name)
  end
end
