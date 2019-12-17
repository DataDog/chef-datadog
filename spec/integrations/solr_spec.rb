describe 'datadog::solr' do
  expected_yaml = <<-EOF
  logs: ~
  instances:
    - host: localhost
      port: 9999
      user: username
      password: password
      process_name_regex: .*process_name.*
      name: solr_instance
      tags:
        env: stage
        newTag: test

  init_config:
    conf:
      - include:
          type: searcher
          attribute:
            maxDoc:
              alias: solr.searcher.maxdoc
              metric_type: gauge
            numDocs:
              alias: solr.searcher.numdocs
              metric_type: gauge
            warmupTime:
              alias: solr.searcher.warmup
              metric_type: gauge
      - include:
          id: org.apache.solr.search.FastLRUCache
          attribute:
            cumulative_lookups:
              alias: solr.cache.lookups
              metric_type: counter
            cumulative_hits:
              alias: solr.cache.hits
              metric_type: counter
            cumulative_inserts:
              alias: solr.cache.inserts
              metric_type: counter
            cumulative_evictions:
              alias: solr.cache.evictions
              metric_type: counter
      - include:
          id: org.apache.solr.search.LRUCache
          attribute:
            cumulative_lookups:
              alias: solr.cache.lookups
              metric_type: counter
            cumulative_hits:
              alias: solr.cache.hits
              metric_type: counter
            cumulative_inserts:
              alias: solr.cache.inserts
              metric_type: counter
            cumulative_evictions:
              alias: solr.cache.evictions
              metric_type: counter
      - include:
          id: org.apache.solr.handler.component.SearchHandler
          attribute:
            errors:
              alias: solr.search_handler.errors
              metric_type: counter
            requests:
              alias: solr.search_handler.requests
              metric_type: counter
            timeouts:
              alias: solr.search_handler.timeouts
              metric_type: counter
            totalTime:
              alias: solr.search_handler.time
              metric_type: counter
            avgTimePerRequest:
              alias: solr.search_handler.avg_time_per_req
              metric_type: gauge
            avgRequestsPerSecond:
              alias: solr.search_handler.avg_requests_per_sec
              metric_type: gauge
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['datadog_monitor']
    ) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }

      node.normal['datadog'] = {
        'api_key' => 'someapikey',
        'solr' => {
          'instances' => [
            {
              host: 'localhost',
              name: 'solr_instance',
              password: 'password',
              port: 9999,
              process_name_regex: '.*process_name.*',
              tags: { env: 'stage', newTag: 'test' },
              user: 'username'
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('solr') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/solr.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
