module DataDog
  def data_bag_item
    name = node['datadog']['databag']['name']
    item = node['datadog']['databag']['item']
    @data_bag_item ||= Chef::EncryptedDataBagItem.load(name, item)
  end

  def check_key(type)
    key_name = "#{type}_key"
    ddog_hash = node['datadog']
    true if ddog_hash[key_name] ||
      (ddog_hash['databag']['name'] && ddog_hash['databag']['item'])
  end

  def get_key(type)
    key_name = "#{type}_key"
    node['datadog'][key_name] || data_bag_item[key_name]
  end
end
