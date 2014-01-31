module DataDog
  def data_bag_item
    name = node['datadog']['databag']['name']
    item = node['datadog']['databag']['item']
    @data_bag_item ||= Chef::EncryptedDataBagItem.load(name, item)
  end

  def check_key(type)
    key_name = "#{type}_key"
    dog_hash = node['datadog']
    dog_hash[key_name] || (dog_hash['databag']['name'] && dog_hash['databag']['item'])
  end

  def get_key(type)
    key_name = "#{type}_key"
    node['datadog'][key_name] || data_bag_item[key_name]
  end
end
