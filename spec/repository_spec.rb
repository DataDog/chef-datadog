describe 'datadog::repository' do
  context 'rhellions' do
    describe 'on versions 5.x and lower' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'centos',
          :version => '5.8'
        ) do |node|
          node.set['languages'] = { 'python' => { 'version' => '2.4.3' } }
        end.converge described_recipe
      end

      it 'sets up a yum repo' do
        expect(chef_run).to add_yum_repository('datadog').with(
          gpgkey: 'http://yum.datadoghq.com/DATADOG_RPM_KEY.public'
        )
      end
    end

    describe 'on versions 6.x and higher' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'centos',
          :version => '6.3'
        ) do |node|
          node.set['languages'] = { 'python' => { 'version' => '2.7.3' } }
        end.converge described_recipe
      end

      it 'sets up a yum repo' do
        expect(chef_run).to add_yum_repository('datadog').with(
          gpgkey: 'https://yum.datadoghq.com/DATADOG_RPM_KEY.public'
        )
      end
    end
  end
end
