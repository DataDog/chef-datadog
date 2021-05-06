Changes
=======

# 4.10.0 / 2021-05-06

* [FEATURE] Support for NPM on Windows [#780][], [#781][] and [#784][] ([@mikezhu-dd][])
* [FEATURE] Implement usage of multiple GPG keys in repofiles, get keys from keys.datadoghq.com [#782][] ([@bkabrda][])
* [FEATURE] Enable yum repository repo_gpgcheck option for Red Hat platforms by default [#789][] and [#793][] ([@bkabrda][])
* [BUGFIX] Added collect_default_metrics: true to kafka.d/conf.yaml [#786][] ([@nilskuehme][])
* [BUGFIX] Set is_jmx in solr template [#791][] ([@albertvaka][])

# 4.9.0 / 2021-02-17
* [FEATURE] allow muting a host during an MSI install [#778][] [@albertvaka][]
* [FEATURE] Kafka recipe: allow setting any conf [#776][] [@albertvaka][]
* [BUGFIX] Fix fatal in error handler if `ddagentuser_name` or `ddagentuser_password` not defined [#777][] [@albertvaka][]
* [BUGFIX] Fix `yum_package[gnupg]` resource being declared more than once [#772][] [@cdonadeo][]

# 4.8.0 / 2020-12-11
* [FEATURE] Add `env` and `log_to_console` options [#759][] [@albertvaka][], and [#760][] [@nilskuehme][]
* [BUGFIX] Fix adding new signing key for apt [#761][] [@nilskuehme][],  [#763][] [@KSerrania][], [#765][] [@albertvaka][] and [#767][] [@nilskuehme][]
* [BUGFIX] Take site option into account in chef-handler config [#762][] [@KSerrania][]

# 4.7.2 / 2020-11-25
* [FEATURE] Trust new signing key [#754][] [@mikezhu-dd][]

# 4.7.1 / 2020-11-25
* [BUGFIX] Revert [#754][]

# 4.7.0 / 2020-11-25
* [FEATURE] Trust new signing key [#754][] [@mikezhu-dd][]
* [FEATURE] Add support for the systemd check [#755][] [@nilskuehme][]
* [FEATURE] Add support for Mongo authentication [#753][] [@nilskuehme][]
* [BUGFIX] Fix conflit with gnupg2 on RHEL8/CentOS8 [#750][] [@haidars][]

# 4.6.0 / 2020-10-15
* [BUGFIX] Explicitly require yaml. See[#749][] [@albertvaka][]
* [BUGFIX] Increase Windows MSI install timeout to 1200 seconds. See [#746][] [@mikezhu-dd][]
* [BUGFIX] Network plugin yaml nesting. See [#739][] [@swalberg][]
* [BUGFIX] Fix syntax issues in README examples. See [#744][] [@jimdaga][]
* [FEATURE] [circlci] Add tests for Chef 16.5.77. See [#741][] [@truthbk][]
* [BUGFIX] [spec] Fix hardcoded paths. See [#742][] [@albertvaka][]
* [BUGFIX] Adds generated recipes for missing checks. See [#730][] [@albertvaka][]
* [FEATURE] Update docs to include us3 region. See [#740][] [@albertvaka][]

# 4.5.0 / 2020-09-02
* [FEATURE] [cassandra] add support for failures/timeouts/unavailable collection. See [#725][] [@k2v][]
* [FEATURE] Add timeout management for Mongo integration. See [#728][] [@Azraeht][]
* [FEATURE] add support for the timeout setting for Rabbitmq. See [#729][] [@ABrehm264][]
* [FEATURE] Install dd agent with yum on Amazon Linux 1. See [#731][] [@tymartin-novu][]
* [FEATURE] Add third-party integrations support. See [#734][] [@julien-lebot][]
* [FEATURE] Add Amazon Linux 2 to kitchen tests. See [#735][] [@julien-lebot][]
* [BUGFIX] Set windows credentials as sensitive. See [#722][] [@julien-lebot][]
* [BUGFIX] Remove duplicate attribute. See [#727][] [@julien-lebot][]
* [BUGFIX] Make dd-agent recipe idempotent. See [#736][] [@julien-lebot][]
* [MISC] Warn when the Agent will start despite being disabled. See [#732][] [@albertvaka][]

# 4.4.0 / 2020-06-19
* [FEATURE] Add support for `datadog-iot-agent` agent flavor. See [#717][]
* [BUGFIX] Do not crash if agent_version doesn't match version regex. See [#711][] [@albertvaka][]
* [BUGFIX] Support '+' sign (for nightlies) in agent version. See [#712][] [@albertvaka][]
* [BUGFIX] Fix Proxy configuration with authentication. See [#714][] [@fatbasstard][]
* [BUGFIX] Fix link to win32_event_log sample config. See [#715][] [@albertvaka][]
* [BUGFIX] Do not crash if the agent is not running. See [#718][] [@albertvaka][]

# 4.3.0 / 2020-04-30
* [FEATURE] Allow configuration of log collection via `datadog['logs_agent_config']`. See [#704][] [@Nibons][]
* [FEATURE] Update the list of Cassandra metrics to collect from JMX. See [#708][] [@k2v][]
* [FEATURE] Add `combine_connection_states` and `collect_count_metrics` to network check. See [#650][] [@danjamesmay][]
* [FEATURE] Create `install_info` file with version info for Chef and the cookbook. See [#707][] [@kbogtob][]
* [BUGFIX] Fix `datadog_monitor` action `:delete` always using Agent 5's path. See [#709][] [@albertvaka][]
* [BUGFIX] Use `true` and `false` instead of `yes` and `no` for `skip_ssl_validation`. See [#693][] [@jaxi]

# 4.2.1 / 2020-03-03

* [REVERT] Reverted PR [#691][] and [#694][] in order to allow users to install Agent on Windows without credentials. See [#699][] [@kbogtob][]

# 4.2.0 / 2020-02-27 - KNOWN BUG

* [FEATURE] Automatically uninstall and then install the Agent only when trying to downgrade agent version on Windows. See [#690][] [@kbogtob][]
* [BUGFIX] Set Windows installer as sensitive resource and use env var to specify Windows user credentials to avoid leaks of credentials in logs. See [#691][] and [#694][] [@julien-lebot][] - Known bug: This bugfix introduces a new bug blocking users not using credentials to install on Windows
* [FEATURE] Support tags feature on directory integration. See [#687][] [@dimier]
* [FEATURE] Support options feature on memcache integration. See [#689][] [@mikelaning]

# 4.1.1 / 2020-01-28

* [BUGFIX] Fix version formating for Linuxes that use yum. See [#685][] [@albertvaka][]

# 4.1.0 / 2020-01-21

* [FEATURE] Automatically format the agent version on debianoids so that every OS can be configured with the same format for the agent version. See [#675][] [@albertvaka][]

# 4.0.1 / 2019-12-31

* [BUGFIX] Fix issues with permissions during monitor directory creation on windows. See [#678][] [@truthbk][]

# 4.0.0 / 2019-12-18

## Breaking changes

  * **This cookbook will install Agent 7.x by default**. Datadog Agent 7 uses Python 3 so
  if you were running any custom checks written in Python, they must now be compatible with
  Python 3. If you were not running any custom checks or if your custom checks are already
  compatible with Python 3, then it is safe to upgrade to Agent 7.

  * **Some config parameters prefixed with `agent6` have been renamed** to accomodate the
  inclusion of Agent 7. Please read the [docs]() for more details about the name changes
  and update your configuration accordingly.

# 3.5.1 / 2019-12-18

* [BUGFIX] Create check `.d` directory if it doesn't exist. See [#670][] [@albertvaka][]

# 3.5.0 / 2019-12-17

* [FEATURE] Allow integrations to have multiple configurations by creating the default configuration into a `.d` folder. See [#666][] [@kbogtob][]
* [BUGFIX] Fix the support of mesos integrations by separating the mesos slave and master integrations. See [#667][] [@kbogtob][]

# 3.4.1 / 2019-11-15

* [FEATURE] Windows: add MSI max timeout knob. See [#654][] [@truthbk][]
* [BUGFIX] Windows: Use windows_agent_url to download script. See [#656][] [@olivielpeau][]
* [BUGFIX] Windows: use chef facilities instead of powershell to download 6.14 fix script. See [#657][] [@truthbk][]
* [BUGFIX] Windows: fix permission inheritance of config directory. See [#653][] [@albertvaka][]

# 3.4.0 / 2019-11-11

* [FEATURE] Blacklist installation of 6.14.0 and 6.14.1. See [#652][] [@truthbk][]
* [FEATURE] Run fix + sanity check script before agent uninstalls. See [#652][] [@truthbk][]
* [FEATURE] Add SSL config for RedisDB [#643][] [@Velgus][]
* [FEATURE] Add a setting to disable writing system-probe.yaml [#648][] [@albertvaka][]
* [BUGFIX] Fix system-probe.yaml ownership [#647][] [@kevinconaway][]

# 3.3.0 / 2019-09-25

* [FEATURE] Add RHEL8/Fedora 28 support (needs Chef >= 15). See [#641][] [@KSerrania][]
* [OPTIMIZE] Add support of the `cmd_port` and `gui_port` fields in Agent config template. See [#632][] [@iashwash][] [@MCKrab][]
* [OPTIMIZE] Add support of the `ssl_ca_cert` field in the vault template. See [#624][] [@jschirle73][]
* [OPTIMIZE] Improve the README examples for the `extra_config` field. See [#639][] [@nicholas-devlin][]

# 3.2.0 / 2019-07-25

* [FEATURE] Support the `extra_config` field in the system-probe recipe. See [#635][] [@kevinconaway][]
* [BUGFIX] Fix the support of SLES 15 by supporting recent versions of `gpg` while importing the GPG key. See [#631][] [@KSerrania][]
* [MISC] Allow custom prefix for Windows agent artifact. See [#634][] [@truthbk][]

# 3.1.0 / 2019-07-10

* [FEATURE] Add support of the `system-probe` Agent. See [#626][] [@shang-wang][]
* [OPTIMIZE] Add support of the `extra_config` field in the `process_config` section. See [#628][] [@p-lambert][]

# 3.0.0 / 2019-06-12

## Breaking changes

  * **This cookbook only supports Chef 12.7+.** It means that if you want to continue
  to use this cookbook with a version of Chef `< 12.7`, you will have to use the datadog
  cookbook in a version `< 3.0`. However, we recommend to switch to the `3.x` version
  because there is no plan to update the `2.x` branch with new features for now.
  * **Agent v6 is now installed by default.** You can set `node['datadog']['agent6'] => false` to continue to use Agent v5. Please see the README for more details.
  * The `datadog_monitor` resource doesn't automatically restart the Agent anymore.
  See `recipes/mongo.rb` for an example on how to restart the Agent after `datadog_monitor` has been executed. See the README for more details on the resource.
  * A new attribute `node['datadog']['site']` will let you send the data to either
  the US or the EU site (this applies to the Datadog handler as well). Also, `default['datadog']['url']` is now set to `nil`.
  If not overriden in your cookbook, the Agent will pick which site to send data to based on these two attributes.
  * Drop support for chef-handler-datadog < 0.10.0, please use a more recent version.
  * Add the `datadog_integration` resource to easily control installed integration, more info in the README.
  * Drop Agent v4 compatibility code.

## Details

* [FEATURE] Ensure compatibility with Chef 14 & 15 (drop compatibility with Chef < 12.7). See [#450][] [#597][] [@martinisoft][] [@remeh][]
* [FEATURE] Agent 6 is now installed by default. See [#594][] [@remeh][]
* [FEATURE] Support `jmx_custom_jars` option in Agent v5. See [#595][] [@wolf31o2][]
* [FEATURE] Add `datadog_integration` resource to install integrations. See [#600][] [@remeh][]
* [FEATURE] Add support for `site` option. See [#582][] [@remeh][]
* [FEATURE] Add support of `max_detailed_exchanges` option for RabbitMQ. See [#562][] [@asherf][]
* [OPTIMIZE] `datadog_monitor` doesn't automatically restart the Agent. See [#596][] [@someara][] [@remeh][]
* [OPTIMIZE] Remove deprecated attributes. See [#613][] [@remeh][]
* [MISC] Remove recipes using `easy_install`. See [#591][] [@stefanwb][] [@remeh][]
* [MISC] Drops Agent v4 compatibility code. See [#599][] [@remeh][]

# 2.19.0 / 2019-05-21

* [FEATURE] Provide custom credentials for the Windows Datadog Agent service. [#618][] [@remeh][]

# 2.18.0 / 2019-03-18

**Note for Windows users**: since Agent v6.11, `datadog >= 2.18.0` is
necessary (see README)

* [FEATURE] Let the Windows installer set the permissions on Agent directories and files. [#588][] [@remeh][]
* [BUGFIX] Use Upstart service manager for Ubuntu <15.04. See [#551][] [@rposborne][]
* [MISC] Deprecation log for recipes using easy_install. See [#585][] [@remeh][]
* [MISC] Add optional NGINX monitor attributes. See [#564][] [@spencermpeterson][]
* [DOCS] Add an example for the `extra_config` field. See [#586][] [@remeh][]

# 2.17.0 / 2019-03-01

* [FEATURE] Add support for SLES. See [#505][] [@gmmeyer][]
* [FEATURE] Add `index_stats` parameter for ElasticSearch. See [#568][] [@aymen-chetoui][]
* [FEATURE] Add configuration flag for JMX service discovery in Agent 5. See [#563][] [@wolf31o2][]
* [FEATURE] Add support for list of tags in v6 configuration file. See [#557][] [@skarlupka][]
* [FEATURE] Add vault recipe. See [#555][] [@skarlupka][]
* [FEATURE] Add `min_collection_interval` to mysql template. See [#548][] [@mhebbar1][]
* [OPTIMIZE] Retry on failure when pulling the gpg key. See [#561][] [@remicalixte][]
* [BUGFIX] Fix beans description in tomcat config template. See [#583][] [@remeh][]
* [MISC] Switch to cookstyle. See [#565][] [@jeffbyrnes][]
* [MISC] Bump requirement on `chef_handler`. See [#396][] [@olivielpeau][]

# 2.16.1 / 2018-07-16

* [FEATURE] Add support for `no_proxy` Agent v6 option. See [#549][] [@stonith][]
* [MISC] Fix typo in documentation of `enable_logs_agent` option. See [#544][] [@rsheyd][]

# 2.16.0 / 2018-05-14

* [FEATURE] Support data scrubber config fields for process agent. See [#540][] [@moisesbotarro][]
* [MISC] Document `easy_install_package` removal from Chef 13+. See [#533][] [@olivielpeau][]

# 2.15.0 / 2018-03-21

This release adds full support of Agent 6 on Windows.

* [FEATURE] Support passing arbitrary config options to Datadog handler. See [#532][] [@olivielpeau][]
* [FEATURE] Update version logic for Agent 6 on Windows. See [#530][] [@olivielpeau][]
* [FEATURE] Add support of APM options for Agent 6.0 and clean up beta workarounds. See [#527][] [@olivielpeau][]
* [FEATURE] Set windows values for agent 6. See [#525][] [@rlaveycal][]
* [OPTIMIZE] Update Agent 6 configuration for v6.0.0 stable and higher. See [#531][] [@olivielpeau][]
* [OPTIMIZE] Update deprecated `logs_enabled` attribute. See [#513][] & [#526][] [@eplanet][]
* [OPTIMIZE] Allow configuring `tags_submission_retries` option on handler. See [#508][] [@olivielpeau][]
* [BUGFIX] Force `windows_service` to restart in order to cope with restart error. See [#520][] [@stefanwb][]
* [BUGFIX] Fix default `datadog.yaml` template for Windows. See [#528][] [@olivielpeau][]

# 2.14.1 / 2018-03-05
* [BUGFIX] Fix service provider on Amazon Linux < 2.0. See [#523][] [@olivielpeau][]
* [OPTIMIZE] Remove reference to old expired APT key, keep only newer key. See [#522][] [@olivielpeau][]

# 2.14.0 / 2018-02-27
* [FEATURE] Enable log collection with chef. See [#498][] [@NBParis][]
* [FEATURE] Support process agent configuration in datadog.yaml. See [#511][] [@conorbranagan][]
* [FEATURE] Add recipe for WMI check. See [#499][] [@mlcooper][]
* [FEATURE] Add updated metrics for Cassandra 2.x and 3.x. See [#516][] [@olivielpeau][]
* [FEATURE] Update component for APT repo, and URL for YUM for Agent6. See [#515][] [@olivielpeau][]
* [FEATURE] Consul: support self leader check and network latency checks. See [#501][] [@azuretek][]
* [BUGFIX] RHEL/Amazon linux: add service provider hint for Agent6 + upstart. See [#518][] [@olivielpeau][]

# 2.13.0 / 2017-12-01

* [FEATURE] Add support for Logs, See [#490][] [@tmichelet][]
* [FEATURE] Add go-metro recipe, [#484][] [@iancward][]
* [FEATURE] Add tokumx recipe, [#486][] [@gswallow][]
* [FEATURE] Add couchbase recipe, [#487][] [@gswallow][]
* [FEATURE] Add experimental support of Agent 6 beta RPMs, [#493][] [@olivielpeau][]
* [FEATURE] Allow `disable_ssl_validation` in the apache conf, [#480][] [@stolfi][]
* [BUGFIX] Fix `warn_on_missing_keys` option of redis integration, [#495][] [@iancward][] & [@olivielpeau][]
* [BUGFIX] Fix default log file directory on Windows, [#492][] [@borgilb][] & [@olivielpeau][]
* [BUGFIX] Add check to consul template for `tags` key, [#479][] [@grogancolin][]

# 2.12.0 / 2017-09-28

* [FEATURE] Support of Agent 6 beta for debianoids, [#472][] [@olivielpeau][]
* [FEATURE] Add `tag_families` option to RabbitMQ template, [#437][] & [#460][] [@lefthand][] & [@foobarto][]
* [FEATURE] Bring elasticsearch template up-to-date, [#445][] & [#462][] [@AlexBevan][] & [@kylegoch][]
* [FEATURE] Add `additional_metrics` and `collections` to mongo template , [#463][] [@otterdude97][]
* [OPTIMIZE] Explicitly set `gpgcheck` to true for `yum_repository`, [#458][] [@dafyddcrosby][]
* [BUGFIX] Adding support for amazon linux based images with recent versions of ohai, [#448][] [@frezbo][]
* [BUGFIX] Fix `ssl_verify` option of rabbitmq template, [#474][] [@iancward][]
* [DOCS] Fix missing array braces in supervisord example, [#454][] [@benmanns][]

# 2.11.0 / 2017-09-21

* [FEATURE] Add configuration for the process-agent, [#465][] [@conorbranagan][]
* [FEATURE] Add SNMP recipe, [#436][] [@mlcooper][]
* [OPTIMIZE] Do not include `yum` recipe to avoid overwriting main yum config, [#446][] [@olivielpeau][]
* [BUGFIX] Avoid failures of agent `service` resource with frequent restarts on systemd, [#469][] [@olivielpeau][]

# 2.10.1 / 2017-05-31

* [OPTIMIZE] Add compatibility with `windows` cookbook `3.0`, [#438][] [@olivielpeau][]

# 2.10.0 / 2017-05-08

* [FEATURE] Update nginx configuration template, [#417][] [@iancward][]
* [FEATURE] Add service discovery attributes to `datadog.conf`, [#420][] [@bflad][]
* [FEATURE] Add Kubernetes recipe, [#409][] [@xt99][]
* [FEATURE] Add SQLServer recipe, [#425][] [@mlcooper][]
* [FEATURE] Add disk integration recipe, [#430][] [@iancward][]
* [FEATURE] Add more options to Mongo & Elasticsearch templates, [#424][] [@gkze][]
* [FEATURE] Allow disabling `apm_enabled` in `datadog.conf`, [#428][] [@ed-flanagan][]
* [FEATURE] Let the trace-agent use its own default settings, [#433][] [@olivielpeau][]
* [FEATURE] Allow specifying trace env, [#435][] [@krasnoukhov][]

# 2.9.1 / 2017-03-28

* [BUGFIX] Keep main agent config in `Main` section when `enable_trace_agent` is true, [#419][] [@bflad][]

# 2.9.0 / 2017-03-24

This release should be fully compatible with Chef 13.

**Note for Windows users**: Upgrading to Agent versions >= 5.12.0 should be done using the EXE installer
(see README)

* [FEATURE] Allow configuration of Traces settings in datadog.conf, [#402][] [@mlcooper][]
* [FEATURE] Support upgrades to Windows Agents >= 5.12.0 (EXE installer option), [#410][] [@olivielpeau][]
* [FEATURE] Add `send_policy_tags` option for handler, [#398][] [@olivielpeau][]
* [FEATURE] Add attribute to customize the gem server of the handler, [#413][] [@dsalvador-dsalvador][]
* [OPTIMIZE] Rename `package[apt-transport-https]` resource for Chef 13 compatibility, [#388][] [@bai][]
* [OPTIMIZE] Guard new GPG key from always being downloaded, [#404][] [@iancward][]
* [MISC] Loosen constraint on `chef_handler` cookbook version, [#414][] [@olivielpeau][]
* [MISC] Add constraint on `windows` cookbook version, [#415][] [@olivielpeau][]

# 2.8.1 / 2017-02-03

* [BUGFIX] Fix agent version pinning on Windows, [#400][] [@olivielpeau][]

# 2.8.0 / 2017-01-25

* [FEATURE] Add `ssl_verify` option to RabbitMQ template, [#383][] [@iancward][]
* [FEATURE] Add correct sudo commands to Postfix recipe, [#384][] [@BrentOnRails][] & [@degemer][]
* [FEATURE] Add support for `windows_service` integration, [#387][] [@mlcooper][]
* [FEATURE] Add attributes for package download retries, [#390][] [@degemer][]
* [FEATURE] Add tags blacklist regex attribute for handler, [#397][] [@ABrehm264][] & [@degemer][]
* [FEATURE] Defer evaluation of api and app keys and read from `run_state`, [#395][] [@mfischer-zd][]

# 2.7.0 / 2016-11-15

* [FEATURE] Add `dd-agent` user to `docker` group in `docker`/`docker_daemon` recipes, [#364][] [@jvrplmlmn][]
* [FEATURE] Add support for `system_swap` check, [#372][] [@iancward][]
* [FEATURE] Add ability to pin datadog-agent versions per platform, [#368][] [@mlcooper][]
* [FEATURE] Add support for any config option in `datadog.conf`, [#375][] [@degemer][]
* [FEATURE] Trust new APT and RPM keys, [#365][] [@olivielpeau][]
* [OPTIMIZE] Simplify `postgres.yaml` template, [#380][] [@miketheman][]
* [BUGFIX] Allow instances with no `tags` in `postfix` template, [#374][] [@nyanshak][]

# 2.6.0 / 2016-09-20

* [FEATURE] Allow multiple enpoints/api_keys conf on Agent and handler, [#317][] [@degemer][]
* [FEATURE] Add `kafka` template versioning, [#340][] [@degemer][]
* [FEATURE] Add `gunicorn` support, [#355][] [@mlcooper][]
* [FEATURE] Add attribute to allow agent downgrade, [#359][] [@olivielpeau][]
* [OPTIMIZE] Fully disable dogstatsd when attribute is set to false/nil, [#348][] [@ccannell67][]
* [OPTIMIZE] Use HTTPS for `yumrepo` when applicable, [#351][] [@aknarts][]
* [BUGFIX] Fix agent version test when version contains an epoch, [#357][] [@olivielpeau][]
* [BUGFIX] Fix `datadog-agent-base` removal guard logic on rhellions, [#358][] [@olivielpeau][]
* [BUGFIX] Replace deprecated properties of `yum_repository`, [#361][] & [#362][] [@historus][] & [@olivielpeau][]

# 2.5.0 / 2016-08-08

* [FEATURE] Add support for `extra_packages` agent checks, [#271][] [@tmichelet][]
* [FEATURE] Add Windows support to `remove-dd-agent` recipe (Chef >= 12.6 only), [#332][] [@raycrawford][]
* [FEATURE] Make yum repo GPG key an attribute, [#326][] [@iancward][]
* [FEATURE] Add support for `provider` option in `iis` check, [#324][] [@clmoreno][]
* [FEATURE] Add support for tags in `etcd` check, [#322][] [@stensonb][]
* [FEATURE] Add `developer_mode` option to `datadog.conf`, [#315][] [@olivielpeau][]
* [FEATURE] Add support for `win32_event_log` check, [#314][] [@olivielpeau][]
* [FEATURE] Add `dogstatsd_target` option to `datadog.conf`, [#313][] [@jcftang-r7][]
* [FEATURE] Add support for`custom_metrics` in `postgres` check, [#284][] [@flah00][]
* [OPTIMIZE] Update windows support with many improvements, [#334][] [@brentm5][]
* [OPTIMIZE] Pass the `hostname` attribute to the handler, [#308][] [@gmmeyer][]
* [MISC] Allow non-breaking updates of `chef_handler`, [#291][] [@eherot][]

  **NOTE** The strict version constraint on `chef_handler` had been introduced because the `1.2` minor release
  of `chef_handler` broke compatibility with Chef 11. Chef 11 compatibility has been re-introduced in the `1.3`
  release, we recommend using that version or higher if you use Chef 11.

# 2.4.0 / 2016-05-04

* [FEATURE] Add support for `dns_check`, [#294][] [@nickmarden][]
* [FEATURE] Add support for `directory` check, [#277][] [@kindlyseth][]
* [BUGFIX] Template error in `postgres.yaml`, [#300][], [#304][] [@miketheman][]

# 2.3.0 / 2016-04-25

* [FEATURE] Add support for `go_expvar` check, [#298][] [@hartfordfive][]
* [FEATURE] Allow a String or Hash when configuring Agent tags, [#296][] [@martinisoft][]
* [FEATURE] Allow passing a `tag_prefix` to the handler, [#285][] [@mstepniowski][]
* [FEATURE] Allow Agent config to control service behavior, [#280][] [@hydrant25][] & [@miketheman][]
* [FEATURE] Add `collect_function_metrics` to `postgres` check, [#278][] [@isaacdd][]
* [FEATURE] Add logging configuration overrides, [#273][] [@SupermanScott][] & [@miketheman][]
* [FEATURE] Add `cassandra` template versions, [#263][] [@yannmh][] [@sethrosenblum][] & [@miketheman][]
* [FEATURE] Add `sites` options to `iis` check, [#261][], [@cobusbernard][] & [@miketheman][]
* [FEATURE] Add missing options to `rabbitmq` check, [#232][] [@mattrobenolt][] & [@miketheman][]
* [FEATURE] Add Agent config option for `histogram_*`, [#272][], [@SupermanScott][]
* [FEATURE] Add support for `commandstats` in redis check, [#266][] [@sethrosenblum][]
* [FEATURE] Add support for `ssh_check` check, [#262][] [@wk8][]
* [FEATURE] Add support for custom MySQL queries, [#259][] [@wk8][]
* [FEATURE] Add PHP-FPM recipe, [#253][] [@jridgewell][]
* [FEATURE] Allow `yum_repository` resource to receive proxy options, [#251][] [@RedWhiteMiko][]
* [FEATURE] Add Agent config option for `statsd_metric_namespace`, [#250][] [@MiguelMoll][]
* [FEATURE] Allow use of Agent `web_proxy` config for Handler, [#208][] [@datwiz][]
* [OPTIMIZE] Allow `tags` to be `nil` during Windows Agent install, [#286][] [@rlaveycal][]
* [OPTIMIZE] Apply `sensitive` filter to template renders, [#274][] [@martinisoft][]
* [DOCS] Correct `redisdb` example, [#281][] [@iashwash][]
* [DOCS] Correct `docker_daemon` example, [#276][] [@dlackty][]
* [MISC] Remove `knife.rb` file from repo, [#299][] [@miketheman][]
* [MISC] Convert Kitchen Test to ChefSpec test for `activemq`, [#295][] [@miketheman][]
* [MISC] Add Kitchen tests via CircleCI & kitchen-docker, [@miketheman][]
* [MISC] Update Travis lint/spec tests to use ChefDK-supplied packages, [@miketheman][]

# 2.2.0 / 2015-10-27

* This release deserves a specific callout for a feature that has been finally
  implemented and deserves a major round of applause to [@EasyAsABC123][],
  [@rlaveycal][], [@olivielpeau][] for their efforts in making Windows platform
  support in this cookbook a reality.

* [FEATURE] Add support for `docker_daemon` check, [#249][] [@kurochan][]
* [FEATURE] Add support for `solr` check, [#246][] [@miketheman][]
* [FEATURE] Add support for `system_core` check, [#243][] [@miketheman][]
* [FEATURE] Add support for `consul` check, [#238][] [@wk8][] & [@darron][]
* [FEATURE] Add `ssl` support for `postgres` check, [#237][] [@uzyexe][]
* [FEATURE] Add support for `etcd` check, [#235][] [@zshenker][] & [@darron][]
* [FEATURE] Add RPM signature check, [#225][] [@elafarge][], [#240][] [@miketheman][]
* [FEATURE] Add missing `varnish` check options, [#224][] [@hilli][]
* [FEATURE] Add timeout option to `elasticsearch` check, [#223][] [@dominicchan][]
* [FEATURE] Add per-shard config toggles to `elasticsearch` check. **Agent 5.5.0+**, [#221][] [@elafarge][]
* [FEATURE] Add per-check tagging to `datadog.conf`. **Agent 5.5.0+**, [#220][] [@elafarge][] [ref](https://github.com/DataDog/dd-agent/pull/1570)
* [FEATURE] Add port for `mysql` check, [#217][] [@NathanielMichael][]
* [FEATURE] **Add support for Windows**, [#210][] [@EasyAsABC123][], [@rlaveycal][], [@olivielpeau][]
* [FEATURE] Add `skip_ssl_validation` toggle to the datadog config file, [#209][] [@ABrehm264][]
* [FEATURE] Add support for `supervisord` check, [#204][] [@DorianZaccaria][]
* [FEATURE] Add support for `pgbouncer` check, [#198][] [@DorianZaccaria][]
* [FEATURE] Update options for `redisdb` check, [#185][] [@opsline-radek][], [@miketheman][] (specs)
* [FEATURE] Add support for `postfix` check, [#167][] [@phlipper][]
* [BUGFIX] Fix `kafka` template `tags`, [#244][] [@LeoCavaille][]
* [BUGFIX] Fix `updated_by_last_action` value of `monitor` provider, [#229][] [@olivielpeau][]
* [BUGFIX] Make `zookeeper` check `timeout` optional, [#227][] [@olivielpeau][]
* [OPTIMIZE] Detect virtual package prior to removal, [#247][] [@dwradcliffe][]
* [OPTIMIZE] Add source & issues URLs for Supermarket, [#248][] [@jeffbyrnes][]
* [OPTIMIZE] Skip `dd-handler` recipe in `why-run` mode, [#231][] [@olivielpeau][]
* [OPTIMIZE] Add `apt-transport-https` for deb-based repo install, [#219][] [@darron][]
* [OPTIMIZE] Change rights on Agent configuration files, [#218][] [@olivielpeau][]
* [OPTIMIZE] Updates to `manage` LWRP, [#212][] [@jmanero-r7][]
* [DOCS] Correct `jmx` example, [#245][] [@tejom][]
* [DOCS] Correct `kafka` example, [#205][] [@elafarge][]
* [DOCS] Correct `fluentd` example, [#203][] [@inokappa][]
* [MISC] Add Rake task for cleanup, [#216][] [@miketheman][]
* [MISC] Update `guard` and `Guardfile`, [#215][] [@miketheman][]
* [MISC] Create ChefSpec matchers for spec testing, [@miketheman][]
* [MISC] Update `jmx` tests for accurate structure, [@miketheman][]
* [MISC] Update libraries used in test suite, [@miketheman][]

# 2.1.0 / 2015-04-20

* [FEATURE] Add support for `mesos` check, [#200][] [@DorianZaccaria][]
* [FEATURE] Add support for `docker` check, [#197][] [@DorianZaccaria][]
* [OPTIMIZE] Set compile_time when using chef_gem resource, [#196][] [@miketheman][]
* [FEATURE] Add support for `ntp` check, [#182][] [@chrissnell][], [@miketheman][]
* [OPTIMIZE] Remove long-dead `debug_mode` and replace with `log_level`, [#187][] [@remh][]
* [FEATURE] Add support for `http` & `tcp` monitoring check, [#177][] [@mtougeron][], [#178][] [@chrissnell][], [@miketheman][]
* [FEATURE] Add support for `fluentd` monitoring check, [#191][] [@takus][], [#192][] [@miketheman][]
* [FEATURE] Add support for process monitoring check, [#190][] [@jpcallanta][]
* [FEATURE] Add configuration flags to elasticsearch template, [#169][] [@chrissnell][]
* [FEATURE] Add configuration flag to control collection of EC2 tags from Agent, [#159][] [@mirceal][]
* [FEATURE] Add Agent package attribute to control package provider action, [#127][], [#147][] [@miketheman][]
* [OPTIMIZE] Use hkp keyserver URL on debianoids, [#138][] [@khouse][]
* [BUGFIX] Use correct indentation for kafka recipe, correct values, add tests, [#163][], [@donaldguy][] & [@miketheman][]
* [BUGFIX] Use correct indentation for activemq recipe, correct param, add tests, [#171][] [@SelerityMichael][] & [@miketheman][]
* [FEATURE] Add support for bind_host parameter, [#148][] [@jblancett][]
* [FEATURE] Add support for Fedora platform, [#135][] [@juliandunn][]
* [FEATURE] Add recipe for package removal, [#125][] [@bitmonk][]
* [FEATURE] Add support for custom emitters, [#123][] [@arthurnn][] & [@graemej][]
* [FEATURE] Add support for statsd forwarding in config file, [#117][] [@ctrlok][]
* [BUGFIX] Simplify JMX configuration, [#116][] [@miketheman][]

  **NOTE** This has been broken for some time, and has had multiple attempts at fixing properly. The correct interface
  has never been documented, and the implementation has always been left up to the reader. We have changed this to be
  much simpler - instead of trying to account for any possible methods

* [BUGFIX] Correct cassandra template render flags, [@miketheman][]
* [DOCS] Remove suggestion for python cookbook, as it is no longer needed. [@miketheman][]
* [MISC] Updates to test suite for simplicity, deprecation warnings, dependencies [@miketheman][] & [@darron][]

# 2.0.0 / 2014-08-22

* **BREAKING CHANGE**: Datadog Agent 5.0.0 Release Edition

  With the release of Datadog Agent 5.x, all Python dependencies are now bundled, and extensions for monitoring are no
  longer needed. Integration-specific recipes no longer install any packages, so if you are using a version older than
  5.x, you may have to install these yourself. This greatly simplifies deployment of all components for monitoring.
  See commit b77582122f3db774a838f90907b421e544dd099c for the exact package resources that have been removed.
  Affected recipes:

  - hdfs
  - memcache
  - mongodb
  - mysql
  - postgres
  - redisdb

* **BREAKING CHANGE**: Removed chef_gem support for Chef versions pre 0.10.9.

  We haven't supported this version of Chef in some time, so it's unlikely that you will be affected at all.
  Just in case, please review what versions of Chef you have installed, and use an older version of this cookbook until
  you can upgrade them.

* [OPTIMIZE] Update repository recipe to choose correct arch, [@remh][]
* [OPTIMIZE] Remove conditional python dep for Ubuntu 11.04, [@miketheman][]
* [OPTIMIZE] Remove extra `apt-get` call during Agent recipe run, [@miketheman][]
* [FEATURE] Add `kafka` monitoring recipe & tests, [#113][] [@qqfr2507][]
* [FEATURE] Allow database name to be passed into postgres template, [@miketheman][]
* [MISC] Many updates to testing suite. Faster style, better specs. [@miketheman][]

# 1.2.0 / 2014-03-24

* [FEATURE] Add `relations` parameter to Postgres check config, [#97][] [@miketheman][]
* [FEATURE] Add `sock` parameter to MySQL check configuration, [#105][] [@thisismana][]
* [FEATURE] Add more parameters to the haproxy templte to collect status metrics, [#103][] [@evan2645][] & [@miketheman][]
* [FEATURE] `datadog::mongo` recipe now installs `pymongo` and prerequisites, [#81][] [@dwradcliffe][]
* [FEATURE] Allow attribute control over whether to allow the local Agent to handle non-local traffic, [#100][] [@coosh][]
* [FEATURE] Allow attribute control over whether the Chef Handler is activated, [#95][] [@jedi4ever][], [@miketheman][]
* [FEATURE] Allow attribute control over whether Agent should be running, [#94][] [@jedi4ever][], [@miketheman][]
* [FEATURE] Reintroduce attribute config for dogstatsd daemon, [#90][] [@jedi4ever][], [@miketheman][]
* [FEATURE] Allow jmx template to accept arbitrary `key, value` statements, [#93][] [@clofresh][]
* [FEATURE] Allow cassandra/zookeeper templates to accept arbitrary `key, value` statements, [@miketheman][]
* [FEATURE] Add name param to varnish recipe, [#86][] [@clofresh][]
* [FEATURE] Allow attribute-driven settings for web proxy, [#82][]  [@antonio-osorio][]
* [FEATURE] Allow override of Agent config for hostname via attribute, [#76][] [@ryandjurovich][]
* [FEATURE] Allow for non-conf.d integrations to be set via attributes, [#66][] [@babbottscott][]
* [FEATURE] added hdfs recipe and template, [#77][] [@phlipper][]
* [FEATURE] added zookeeper recipe and template, [#74][] [@phlipper][]
* [BUGFIX] Warn user when more than one `network` instance is defined, [#98][] [@miketheman][]
* [BUGFIX] Properly indent jmx template, [#88][] [@flah00][]
* [BUGFIX] Handle unrecognized Python version strings in a better fashion, [#79][] [#80][] [#84][], [@jtimberman][], [@schisamo][], [@miketheman][]
* [BUGFIX] Set gpgcheck to false for `yum` repo if it exists, [#89][] [@alexism][], [#101][] [@nkts][]
* [MISC] Inline doc for postgres recipe, [#83][] [@timusg][]


# 1.1.1 / 2013-10-17

* [FEATURE] added rabbitmq recipe and template, [@miketheman][]
* [BUGFIX] memcache dependencies and template, [#67][] [@elijahandrews][]
* [BUGFIX] redis python client check was not properly checking the default version, [@remh][]
* [MISC] tailor 1.3.1 caught some cosmetic issue, [@alq][]

# 1.1.0 / 2013-08-20

* [FEATURE] Parameterize chef-handler-datadog Gem version, [#60][] [@mfischer-zd][]
* [FEATURE] Allow control of `network.yaml` via attributes, [#63][] [@JoeDeVries][]
* [FEATURE] Use Python version from Ohai to determine packages to install, [#65][] [@elijahandrews][]
* [BUGFIX] redisdb default port in template should be 6379, [#59][] [@miketheman][]
* [BUGFIX] templates creating empty `tags` in config when unspecified for multiple integrations [#61][] [@alq][]
* [MISC] updated tests [@elijahandrews][], [@miketheman][]
* [MISC] correct the riak integration example, [@miketheman][]
* [MISC] updated CHANGELOG.md style, [@miketheman][]

#### Dependency Note
One of the dependencies of this cookbook is the `apt` cookbook.
A change introduced in the `apt` cookbook 2.0.0 release was a Chef 11-specific feature that would break on any Chef 10 system, so we considered adding a restriction in our `metadata.rb` to anything below 2.0.0.

A fix has gone in to `apt` 2.1.0 that relaxes this condition, and plays well with both Chef 10 and 11. We recommend using this version, or higher.

# 1.0.1 / 2013-05-14

* Fixed iis and rabbitmq template syntax - [#58][] [@gregf][]
* Updated style/spacing in ActiveMQ template
* Updated test suite to validate cookbook & templates
* Updated chefignore to clean the built cookbook from containing cruft

# 1.0.0 / 2013-05-06

* **BREAKING CHANGE**: Moved all attributes into `datadog` namespace - [#46][] ([#23][], [#26][])

  Reasoning behind this was that originally we attempted to auto-detect many common attributes and deploy automatic monitoring for them.
  We found that since inclusion of the `datadog` cookbook early in the run list caused the compile phase to be populated with our defaults (mostly `nil`), instead of the desired target, and namespacing of the attributes became necessary.

* **NEW PROVIDER**: Added a new `datadog_monitor` provider for integration use

  The new provider is used in many pre-provided integration recipes, such as `datadog::apache`.
  This enables a run list to include this recipe, as well as populate a node attribute with the needed instance details to monitor the given service

* Updated dependencies in Gemfile, simplifies travis build - [#34][], [#55][]
* Much improved test system (chefspec, test-kitchen) - [#35][] & others
* Tests against multiple versions of Chef - [#18][]
* Added language-specific recipes for installing `dogstatsd` - ([#28][])
* Added ability to control `dogstatsd` from agent config via attribute - [#27][]
* Placed the `dogstatsd` log file in `/var/log/` instead of `/tmp`
* Added attribute to configure dogstreams in `datadog.conf` - [#37][]
* Updated for `platform_family` semantics
* Added `node['datadog']['agent_version']` attribute
* (Handler Recipe) Better handling of EC2 instance ID for Handler - [#44][]
* Updated for agent 3.6.x logging syntax
* Generated config file removes some whitespace - [#56][]
* Removed dependency on `yum::epel`, only uses `yum` for the `repository` recipe


# 0.1.4 / 2013-04-25
* Quick fix for backporting test code to support upload in ruby 1.8.7

# 0.1.3 / 2013-01-27
* Work-around for COOK-2171

# 0.1.2 / 2012-10-15
* Fixed typo in jmx section

# 0.1.1 / 2012-09-18
* Added support for postgres, redis & memcached
* `dd-agent` - updated to include more platforms
* `dd-handler` - updated to leverage `chef_gem` resource if available
* Updated copyright for 2012
* Updated syntax for node attribute accessors
* Some syntax styling fixes
* Added agent logging configuration
* Removed extraneous dependencies
* Added automated testing suite

# 0.0.12
* Updated for CentOS dependencies

# 0.0.11
* Link to github repository.

# 0.0.10
* `dd-handler` - Corrects attribute name.

# 0.0.9
* `dd-agent` - Adds an explicit varnish attribute.

# 0.0.8
* `dd-agent` - Add varnish support.

# 0.0.7
* `dd-agent` - default to using instance IDs as hostnames when running dd-agent on EC2

# 0.0.5
* `dd-agent` - Full datadog.conf template using attributes (thanks [@drewrothstein][])

# 0.0.4
* `dd-agent` - Added support for Nagios PerfData and Graphite.

# 0.0.3
* `dd-agent` - Added support for RPM installs - Red Hat, CentOS, Scientific, Fedora

# 0.0.2
* Initial refactoring, including the `dd-agent` cookbook here
* Adding chef-handler-datadog to report to the newsfeed
* Added ruby-dev dependency

[docs]: https://github.com/DataDog/chef-datadog/blob/master/README.md

<!--- The following link definition list is generated by PimpMyChangelog --->
[#18]: https://github.com/DataDog/chef-datadog/issues/18
[#22]: https://github.com/DataDog/chef-datadog/issues/22
[#23]: https://github.com/DataDog/chef-datadog/issues/23
[#26]: https://github.com/DataDog/chef-datadog/issues/26
[#27]: https://github.com/DataDog/chef-datadog/issues/27
[#28]: https://github.com/DataDog/chef-datadog/issues/28
[#34]: https://github.com/DataDog/chef-datadog/issues/34
[#35]: https://github.com/DataDog/chef-datadog/issues/35
[#37]: https://github.com/DataDog/chef-datadog/issues/37
[#44]: https://github.com/DataDog/chef-datadog/issues/44
[#46]: https://github.com/DataDog/chef-datadog/issues/46
[#55]: https://github.com/DataDog/chef-datadog/issues/55
[#56]: https://github.com/DataDog/chef-datadog/issues/56
[#58]: https://github.com/DataDog/chef-datadog/issues/58
[#59]: https://github.com/DataDog/chef-datadog/issues/59
[#60]: https://github.com/DataDog/chef-datadog/issues/60
[#61]: https://github.com/DataDog/chef-datadog/issues/61
[#63]: https://github.com/DataDog/chef-datadog/issues/63
[#65]: https://github.com/DataDog/chef-datadog/issues/65
[#66]: https://github.com/DataDog/chef-datadog/issues/66
[#67]: https://github.com/DataDog/chef-datadog/issues/67
[#74]: https://github.com/DataDog/chef-datadog/issues/74
[#76]: https://github.com/DataDog/chef-datadog/issues/76
[#77]: https://github.com/DataDog/chef-datadog/issues/77
[#79]: https://github.com/DataDog/chef-datadog/issues/79
[#80]: https://github.com/DataDog/chef-datadog/issues/80
[#81]: https://github.com/DataDog/chef-datadog/issues/81
[#82]: https://github.com/DataDog/chef-datadog/issues/82
[#83]: https://github.com/DataDog/chef-datadog/issues/83
[#84]: https://github.com/DataDog/chef-datadog/issues/84
[#86]: https://github.com/DataDog/chef-datadog/issues/86
[#88]: https://github.com/DataDog/chef-datadog/issues/88
[#89]: https://github.com/DataDog/chef-datadog/issues/89
[#90]: https://github.com/DataDog/chef-datadog/issues/90
[#93]: https://github.com/DataDog/chef-datadog/issues/93
[#94]: https://github.com/DataDog/chef-datadog/issues/94
[#95]: https://github.com/DataDog/chef-datadog/issues/95
[#97]: https://github.com/DataDog/chef-datadog/issues/97
[#98]: https://github.com/DataDog/chef-datadog/issues/98
[#100]: https://github.com/DataDog/chef-datadog/issues/100
[#101]: https://github.com/DataDog/chef-datadog/issues/101
[#103]: https://github.com/DataDog/chef-datadog/issues/103
[#105]: https://github.com/DataDog/chef-datadog/issues/105
[#113]: https://github.com/DataDog/chef-datadog/issues/113
[#116]: https://github.com/DataDog/chef-datadog/issues/116
[#117]: https://github.com/DataDog/chef-datadog/issues/117
[#123]: https://github.com/DataDog/chef-datadog/issues/123
[#125]: https://github.com/DataDog/chef-datadog/issues/125
[#127]: https://github.com/DataDog/chef-datadog/issues/127
[#135]: https://github.com/DataDog/chef-datadog/issues/135
[#138]: https://github.com/DataDog/chef-datadog/issues/138
[#147]: https://github.com/DataDog/chef-datadog/issues/147
[#148]: https://github.com/DataDog/chef-datadog/issues/148
[#159]: https://github.com/DataDog/chef-datadog/issues/159
[#163]: https://github.com/DataDog/chef-datadog/issues/163
[#167]: https://github.com/DataDog/chef-datadog/issues/167
[#169]: https://github.com/DataDog/chef-datadog/issues/169
[#171]: https://github.com/DataDog/chef-datadog/issues/171
[#177]: https://github.com/DataDog/chef-datadog/issues/177
[#178]: https://github.com/DataDog/chef-datadog/issues/178
[#182]: https://github.com/DataDog/chef-datadog/issues/182
[#185]: https://github.com/DataDog/chef-datadog/issues/185
[#187]: https://github.com/DataDog/chef-datadog/issues/187
[#190]: https://github.com/DataDog/chef-datadog/issues/190
[#191]: https://github.com/DataDog/chef-datadog/issues/191
[#192]: https://github.com/DataDog/chef-datadog/issues/192
[#196]: https://github.com/DataDog/chef-datadog/issues/196
[#197]: https://github.com/DataDog/chef-datadog/issues/197
[#198]: https://github.com/DataDog/chef-datadog/issues/198
[#200]: https://github.com/DataDog/chef-datadog/issues/200
[#203]: https://github.com/DataDog/chef-datadog/issues/203
[#204]: https://github.com/DataDog/chef-datadog/issues/204
[#205]: https://github.com/DataDog/chef-datadog/issues/205
[#208]: https://github.com/DataDog/chef-datadog/issues/208
[#209]: https://github.com/DataDog/chef-datadog/issues/209
[#210]: https://github.com/DataDog/chef-datadog/issues/210
[#212]: https://github.com/DataDog/chef-datadog/issues/212
[#215]: https://github.com/DataDog/chef-datadog/issues/215
[#216]: https://github.com/DataDog/chef-datadog/issues/216
[#217]: https://github.com/DataDog/chef-datadog/issues/217
[#218]: https://github.com/DataDog/chef-datadog/issues/218
[#219]: https://github.com/DataDog/chef-datadog/issues/219
[#220]: https://github.com/DataDog/chef-datadog/issues/220
[#221]: https://github.com/DataDog/chef-datadog/issues/221
[#223]: https://github.com/DataDog/chef-datadog/issues/223
[#224]: https://github.com/DataDog/chef-datadog/issues/224
[#225]: https://github.com/DataDog/chef-datadog/issues/225
[#227]: https://github.com/DataDog/chef-datadog/issues/227
[#229]: https://github.com/DataDog/chef-datadog/issues/229
[#231]: https://github.com/DataDog/chef-datadog/issues/231
[#232]: https://github.com/DataDog/chef-datadog/issues/232
[#235]: https://github.com/DataDog/chef-datadog/issues/235
[#237]: https://github.com/DataDog/chef-datadog/issues/237
[#238]: https://github.com/DataDog/chef-datadog/issues/238
[#240]: https://github.com/DataDog/chef-datadog/issues/240
[#243]: https://github.com/DataDog/chef-datadog/issues/243
[#244]: https://github.com/DataDog/chef-datadog/issues/244
[#245]: https://github.com/DataDog/chef-datadog/issues/245
[#246]: https://github.com/DataDog/chef-datadog/issues/246
[#247]: https://github.com/DataDog/chef-datadog/issues/247
[#248]: https://github.com/DataDog/chef-datadog/issues/248
[#249]: https://github.com/DataDog/chef-datadog/issues/249
[#250]: https://github.com/DataDog/chef-datadog/issues/250
[#251]: https://github.com/DataDog/chef-datadog/issues/251
[#253]: https://github.com/DataDog/chef-datadog/issues/253
[#259]: https://github.com/DataDog/chef-datadog/issues/259
[#261]: https://github.com/DataDog/chef-datadog/issues/261
[#262]: https://github.com/DataDog/chef-datadog/issues/262
[#263]: https://github.com/DataDog/chef-datadog/issues/263
[#266]: https://github.com/DataDog/chef-datadog/issues/266
[#271]: https://github.com/DataDog/chef-datadog/issues/271
[#272]: https://github.com/DataDog/chef-datadog/issues/272
[#273]: https://github.com/DataDog/chef-datadog/issues/273
[#274]: https://github.com/DataDog/chef-datadog/issues/274
[#276]: https://github.com/DataDog/chef-datadog/issues/276
[#277]: https://github.com/DataDog/chef-datadog/issues/277
[#278]: https://github.com/DataDog/chef-datadog/issues/278
[#280]: https://github.com/DataDog/chef-datadog/issues/280
[#281]: https://github.com/DataDog/chef-datadog/issues/281
[#284]: https://github.com/DataDog/chef-datadog/issues/284
[#285]: https://github.com/DataDog/chef-datadog/issues/285
[#286]: https://github.com/DataDog/chef-datadog/issues/286
[#291]: https://github.com/DataDog/chef-datadog/issues/291
[#294]: https://github.com/DataDog/chef-datadog/issues/294
[#295]: https://github.com/DataDog/chef-datadog/issues/295
[#296]: https://github.com/DataDog/chef-datadog/issues/296
[#298]: https://github.com/DataDog/chef-datadog/issues/298
[#299]: https://github.com/DataDog/chef-datadog/issues/299
[#300]: https://github.com/DataDog/chef-datadog/issues/300
[#304]: https://github.com/DataDog/chef-datadog/issues/304
[#308]: https://github.com/DataDog/chef-datadog/issues/308
[#313]: https://github.com/DataDog/chef-datadog/issues/313
[#314]: https://github.com/DataDog/chef-datadog/issues/314
[#315]: https://github.com/DataDog/chef-datadog/issues/315
[#317]: https://github.com/DataDog/chef-datadog/issues/317
[#322]: https://github.com/DataDog/chef-datadog/issues/322
[#324]: https://github.com/DataDog/chef-datadog/issues/324
[#326]: https://github.com/DataDog/chef-datadog/issues/326
[#332]: https://github.com/DataDog/chef-datadog/issues/332
[#334]: https://github.com/DataDog/chef-datadog/issues/334
[#340]: https://github.com/DataDog/chef-datadog/issues/340
[#348]: https://github.com/DataDog/chef-datadog/issues/348
[#351]: https://github.com/DataDog/chef-datadog/issues/351
[#355]: https://github.com/DataDog/chef-datadog/issues/355
[#357]: https://github.com/DataDog/chef-datadog/issues/357
[#358]: https://github.com/DataDog/chef-datadog/issues/358
[#359]: https://github.com/DataDog/chef-datadog/issues/359
[#361]: https://github.com/DataDog/chef-datadog/issues/361
[#362]: https://github.com/DataDog/chef-datadog/issues/362
[#364]: https://github.com/DataDog/chef-datadog/issues/364
[#365]: https://github.com/DataDog/chef-datadog/issues/365
[#368]: https://github.com/DataDog/chef-datadog/issues/368
[#372]: https://github.com/DataDog/chef-datadog/issues/372
[#374]: https://github.com/DataDog/chef-datadog/issues/374
[#375]: https://github.com/DataDog/chef-datadog/issues/375
[#380]: https://github.com/DataDog/chef-datadog/issues/380
[#383]: https://github.com/DataDog/chef-datadog/issues/383
[#384]: https://github.com/DataDog/chef-datadog/issues/384
[#387]: https://github.com/DataDog/chef-datadog/issues/387
[#388]: https://github.com/DataDog/chef-datadog/issues/388
[#390]: https://github.com/DataDog/chef-datadog/issues/390
[#395]: https://github.com/DataDog/chef-datadog/issues/395
[#396]: https://github.com/DataDog/chef-datadog/issues/396
[#397]: https://github.com/DataDog/chef-datadog/issues/397
[#398]: https://github.com/DataDog/chef-datadog/issues/398
[#400]: https://github.com/DataDog/chef-datadog/issues/400
[#402]: https://github.com/DataDog/chef-datadog/issues/402
[#404]: https://github.com/DataDog/chef-datadog/issues/404
[#409]: https://github.com/DataDog/chef-datadog/issues/409
[#410]: https://github.com/DataDog/chef-datadog/issues/410
[#413]: https://github.com/DataDog/chef-datadog/issues/413
[#414]: https://github.com/DataDog/chef-datadog/issues/414
[#415]: https://github.com/DataDog/chef-datadog/issues/415
[#417]: https://github.com/DataDog/chef-datadog/issues/417
[#419]: https://github.com/DataDog/chef-datadog/issues/419
[#420]: https://github.com/DataDog/chef-datadog/issues/420
[#424]: https://github.com/DataDog/chef-datadog/issues/424
[#425]: https://github.com/DataDog/chef-datadog/issues/425
[#428]: https://github.com/DataDog/chef-datadog/issues/428
[#430]: https://github.com/DataDog/chef-datadog/issues/430
[#433]: https://github.com/DataDog/chef-datadog/issues/433
[#435]: https://github.com/DataDog/chef-datadog/issues/435
[#436]: https://github.com/DataDog/chef-datadog/issues/436
[#437]: https://github.com/DataDog/chef-datadog/issues/437
[#438]: https://github.com/DataDog/chef-datadog/issues/438
[#445]: https://github.com/DataDog/chef-datadog/issues/445
[#446]: https://github.com/DataDog/chef-datadog/issues/446
[#448]: https://github.com/DataDog/chef-datadog/issues/448
[#450]: https://github.com/DataDog/chef-datadog/issues/450
[#454]: https://github.com/DataDog/chef-datadog/issues/454
[#458]: https://github.com/DataDog/chef-datadog/issues/458
[#460]: https://github.com/DataDog/chef-datadog/issues/460
[#462]: https://github.com/DataDog/chef-datadog/issues/462
[#463]: https://github.com/DataDog/chef-datadog/issues/463
[#465]: https://github.com/DataDog/chef-datadog/issues/465
[#469]: https://github.com/DataDog/chef-datadog/issues/469
[#472]: https://github.com/DataDog/chef-datadog/issues/472
[#474]: https://github.com/DataDog/chef-datadog/issues/474
[#479]: https://github.com/DataDog/chef-datadog/issues/479
[#480]: https://github.com/DataDog/chef-datadog/issues/480
[#484]: https://github.com/DataDog/chef-datadog/issues/484
[#486]: https://github.com/DataDog/chef-datadog/issues/486
[#487]: https://github.com/DataDog/chef-datadog/issues/487
[#490]: https://github.com/DataDog/chef-datadog/issues/490
[#492]: https://github.com/DataDog/chef-datadog/issues/492
[#493]: https://github.com/DataDog/chef-datadog/issues/493
[#495]: https://github.com/DataDog/chef-datadog/issues/495
[#498]: https://github.com/DataDog/chef-datadog/issues/498
[#499]: https://github.com/DataDog/chef-datadog/issues/499
[#501]: https://github.com/DataDog/chef-datadog/issues/501
[#505]: https://github.com/DataDog/chef-datadog/issues/505
[#508]: https://github.com/DataDog/chef-datadog/issues/508
[#511]: https://github.com/DataDog/chef-datadog/issues/511
[#513]: https://github.com/DataDog/chef-datadog/issues/513
[#515]: https://github.com/DataDog/chef-datadog/issues/515
[#516]: https://github.com/DataDog/chef-datadog/issues/516
[#518]: https://github.com/DataDog/chef-datadog/issues/518
[#520]: https://github.com/DataDog/chef-datadog/issues/520
[#522]: https://github.com/DataDog/chef-datadog/issues/522
[#523]: https://github.com/DataDog/chef-datadog/issues/523
[#525]: https://github.com/DataDog/chef-datadog/issues/525
[#526]: https://github.com/DataDog/chef-datadog/issues/526
[#527]: https://github.com/DataDog/chef-datadog/issues/527
[#528]: https://github.com/DataDog/chef-datadog/issues/528
[#530]: https://github.com/DataDog/chef-datadog/issues/530
[#531]: https://github.com/DataDog/chef-datadog/issues/531
[#532]: https://github.com/DataDog/chef-datadog/issues/532
[#533]: https://github.com/DataDog/chef-datadog/issues/533
[#540]: https://github.com/DataDog/chef-datadog/issues/540
[#544]: https://github.com/DataDog/chef-datadog/issues/544
[#548]: https://github.com/DataDog/chef-datadog/issues/548
[#549]: https://github.com/DataDog/chef-datadog/issues/549
[#551]: https://github.com/DataDog/chef-datadog/issues/551
[#555]: https://github.com/DataDog/chef-datadog/issues/555
[#557]: https://github.com/DataDog/chef-datadog/issues/557
[#561]: https://github.com/DataDog/chef-datadog/issues/561
[#562]: https://github.com/DataDog/chef-datadog/issues/562
[#563]: https://github.com/DataDog/chef-datadog/issues/563
[#564]: https://github.com/DataDog/chef-datadog/issues/564
[#565]: https://github.com/DataDog/chef-datadog/issues/565
[#568]: https://github.com/DataDog/chef-datadog/issues/568
[#582]: https://github.com/DataDog/chef-datadog/issues/582
[#583]: https://github.com/DataDog/chef-datadog/issues/583
[#585]: https://github.com/DataDog/chef-datadog/issues/585
[#586]: https://github.com/DataDog/chef-datadog/issues/586
[#588]: https://github.com/DataDog/chef-datadog/issues/588
[#591]: https://github.com/DataDog/chef-datadog/issues/591
[#594]: https://github.com/DataDog/chef-datadog/issues/594
[#595]: https://github.com/DataDog/chef-datadog/issues/595
[#596]: https://github.com/DataDog/chef-datadog/issues/596
[#597]: https://github.com/DataDog/chef-datadog/issues/597
[#599]: https://github.com/DataDog/chef-datadog/issues/599
[#600]: https://github.com/DataDog/chef-datadog/issues/600
[#613]: https://github.com/DataDog/chef-datadog/issues/613
[#618]: https://github.com/DataDog/chef-datadog/issues/618
[#624]: https://github.com/DataDog/chef-datadog/issues/624
[#626]: https://github.com/DataDog/chef-datadog/issues/626
[#628]: https://github.com/DataDog/chef-datadog/issues/628
[#631]: https://github.com/DataDog/chef-datadog/issues/631
[#632]: https://github.com/DataDog/chef-datadog/issues/632
[#634]: https://github.com/DataDog/chef-datadog/issues/634
[#635]: https://github.com/DataDog/chef-datadog/issues/635
[#639]: https://github.com/DataDog/chef-datadog/issues/639
[#641]: https://github.com/DataDog/chef-datadog/issues/641
[#643]: https://github.com/DataDog/chef-datadog/issues/643
[#647]: https://github.com/DataDog/chef-datadog/issues/647
[#648]: https://github.com/DataDog/chef-datadog/issues/648
[#650]: https://github.com/DataDog/chef-datadog/issues/650
[#652]: https://github.com/DataDog/chef-datadog/issues/652
[#653]: https://github.com/DataDog/chef-datadog/issues/653
[#654]: https://github.com/DataDog/chef-datadog/issues/654
[#656]: https://github.com/DataDog/chef-datadog/issues/656
[#657]: https://github.com/DataDog/chef-datadog/issues/657
[#666]: https://github.com/DataDog/chef-datadog/issues/666
[#667]: https://github.com/DataDog/chef-datadog/issues/667
[#670]: https://github.com/DataDog/chef-datadog/issues/670
[#675]: https://github.com/DataDog/chef-datadog/issues/675
[#678]: https://github.com/DataDog/chef-datadog/issues/678
[#685]: https://github.com/DataDog/chef-datadog/issues/685
[#687]: https://github.com/DataDog/chef-datadog/issues/687
[#689]: https://github.com/DataDog/chef-datadog/issues/689
[#690]: https://github.com/DataDog/chef-datadog/issues/690
[#691]: https://github.com/DataDog/chef-datadog/issues/691
[#693]: https://github.com/DataDog/chef-datadog/issues/693
[#694]: https://github.com/DataDog/chef-datadog/issues/694
[#699]: https://github.com/DataDog/chef-datadog/issues/699
[#704]: https://github.com/DataDog/chef-datadog/issues/704
[#707]: https://github.com/DataDog/chef-datadog/issues/707
[#708]: https://github.com/DataDog/chef-datadog/issues/708
[#709]: https://github.com/DataDog/chef-datadog/issues/709
[#711]: https://github.com/DataDog/chef-datadog/issues/711
[#712]: https://github.com/DataDog/chef-datadog/issues/712
[#714]: https://github.com/DataDog/chef-datadog/issues/714
[#715]: https://github.com/DataDog/chef-datadog/issues/715
[#717]: https://github.com/DataDog/chef-datadog/issues/717
[#718]: https://github.com/DataDog/chef-datadog/issues/718
[#722]: https://github.com/DataDog/chef-datadog/issues/722
[#725]: https://github.com/DataDog/chef-datadog/issues/725
[#727]: https://github.com/DataDog/chef-datadog/issues/727
[#728]: https://github.com/DataDog/chef-datadog/issues/728
[#729]: https://github.com/DataDog/chef-datadog/issues/729
[#730]: https://github.com/DataDog/chef-datadog/issues/730
[#731]: https://github.com/DataDog/chef-datadog/issues/731
[#732]: https://github.com/DataDog/chef-datadog/issues/732
[#734]: https://github.com/DataDog/chef-datadog/issues/734
[#735]: https://github.com/DataDog/chef-datadog/issues/735
[#736]: https://github.com/DataDog/chef-datadog/issues/736
[#739]: https://github.com/DataDog/chef-datadog/issues/739
[#740]: https://github.com/DataDog/chef-datadog/issues/740
[#741]: https://github.com/DataDog/chef-datadog/issues/741
[#742]: https://github.com/DataDog/chef-datadog/issues/742
[#744]: https://github.com/DataDog/chef-datadog/issues/744
[#746]: https://github.com/DataDog/chef-datadog/issues/746
[#749]: https://github.com/DataDog/chef-datadog/issues/749
[#750]: https://github.com/DataDog/chef-datadog/issues/750
[#753]: https://github.com/DataDog/chef-datadog/issues/753
[#754]: https://github.com/DataDog/chef-datadog/issues/754
[#755]: https://github.com/DataDog/chef-datadog/issues/755
[#759]: https://github.com/DataDog/chef-datadog/issues/759
[#760]: https://github.com/DataDog/chef-datadog/issues/760
[#761]: https://github.com/DataDog/chef-datadog/issues/761
[#762]: https://github.com/DataDog/chef-datadog/issues/762
[#763]: https://github.com/DataDog/chef-datadog/issues/763
[#765]: https://github.com/DataDog/chef-datadog/issues/765
[#767]: https://github.com/DataDog/chef-datadog/issues/767
[#772]: https://github.com/DataDog/chef-datadog/issues/772
[#776]: https://github.com/DataDog/chef-datadog/issues/776
[#777]: https://github.com/DataDog/chef-datadog/issues/777
[#778]: https://github.com/DataDog/chef-datadog/issues/778
[#780]: https://github.com/DataDog/chef-datadog/issues/780
[#781]: https://github.com/DataDog/chef-datadog/issues/781
[#782]: https://github.com/DataDog/chef-datadog/issues/782
[#784]: https://github.com/DataDog/chef-datadog/issues/784
[#786]: https://github.com/DataDog/chef-datadog/issues/786
[#789]: https://github.com/DataDog/chef-datadog/issues/789
[#791]: https://github.com/DataDog/chef-datadog/issues/791
[#793]: https://github.com/DataDog/chef-datadog/issues/793
[@ABrehm264]: https://github.com/ABrehm264
[@AlexBevan]: https://github.com/AlexBevan
[@Azraeht]: https://github.com/Azraeht
[@BrentOnRails]: https://github.com/BrentOnRails
[@DorianZaccaria]: https://github.com/DorianZaccaria
[@EasyAsABC123]: https://github.com/EasyAsABC123
[@JoeDeVries]: https://github.com/JoeDeVries
[@KSerrania]: https://github.com/KSerrania
[@LeoCavaille]: https://github.com/LeoCavaille
[@MCKrab]: https://github.com/MCKrab
[@MiguelMoll]: https://github.com/MiguelMoll
[@NBParis]: https://github.com/NBParis
[@NathanielMichael]: https://github.com/NathanielMichael
[@Nibons]: https://github.com/Nibons
[@RedWhiteMiko]: https://github.com/RedWhiteMiko
[@SelerityMichael]: https://github.com/SelerityMichael
[@SupermanScott]: https://github.com/SupermanScott
[@Velgus]: https://github.com/Velgus
[@aknarts]: https://github.com/aknarts
[@albertvaka]: https://github.com/albertvaka
[@alexism]: https://github.com/alexism
[@alq]: https://github.com/alq
[@antonio-osorio]: https://github.com/antonio-osorio
[@arthurnn]: https://github.com/arthurnn
[@asherf]: https://github.com/asherf
[@aymen-chetoui]: https://github.com/aymen-chetoui
[@azuretek]: https://github.com/azuretek
[@babbottscott]: https://github.com/babbottscott
[@bai]: https://github.com/bai
[@benmanns]: https://github.com/benmanns
[@bflad]: https://github.com/bflad
[@bitmonk]: https://github.com/bitmonk
[@bkabrda]: https://github.com/bkabrda
[@borgilb]: https://github.com/borgilb
[@brentm5]: https://github.com/brentm5
[@ccannell67]: https://github.com/ccannell67
[@cdonadeo]: https://github.com/cdonadeo
[@chrissnell]: https://github.com/chrissnell
[@clmoreno]: https://github.com/clmoreno
[@clofresh]: https://github.com/clofresh
[@cobusbernard]: https://github.com/cobusbernard
[@conorbranagan]: https://github.com/conorbranagan
[@coosh]: https://github.com/coosh
[@ctrlok]: https://github.com/ctrlok
[@dafyddcrosby]: https://github.com/dafyddcrosby
[@danjamesmay]: https://github.com/danjamesmay
[@darron]: https://github.com/darron
[@datwiz]: https://github.com/datwiz
[@degemer]: https://github.com/degemer
[@dimier]: https://github.com/dimier
[@dlackty]: https://github.com/dlackty
[@dominicchan]: https://github.com/dominicchan
[@donaldguy]: https://github.com/donaldguy
[@drewrothstein]: https://github.com/drewrothstein
[@dsalvador-dsalvador]: https://github.com/dsalvador-dsalvador
[@dwradcliffe]: https://github.com/dwradcliffe
[@ed-flanagan]: https://github.com/ed-flanagan
[@eherot]: https://github.com/eherot
[@elafarge]: https://github.com/elafarge
[@elijahandrews]: https://github.com/elijahandrews
[@eplanet]: https://github.com/eplanet
[@evan2645]: https://github.com/evan2645
[@fatbasstard]: https://github.com/fatbasstard
[@flah00]: https://github.com/flah00
[@foobarto]: https://github.com/foobarto
[@frezbo]: https://github.com/frezbo
[@gkze]: https://github.com/gkze
[@gmmeyer]: https://github.com/gmmeyer
[@graemej]: https://github.com/graemej
[@gregf]: https://github.com/gregf
[@grogancolin]: https://github.com/grogancolin
[@gswallow]: https://github.com/gswallow
[@haidars]: https://github.com/haidars
[@hartfordfive]: https://github.com/hartfordfive
[@hilli]: https://github.com/hilli
[@historus]: https://github.com/historus
[@hydrant25]: https://github.com/hydrant25
[@iancward]: https://github.com/iancward
[@iashwash]: https://github.com/iashwash
[@inokappa]: https://github.com/inokappa
[@isaacdd]: https://github.com/isaacdd
[@jaxi]: https://github.com/jaxi
[@jblancett]: https://github.com/jblancett
[@jcftang-r7]: https://github.com/jcftang-r7
[@jedi4ever]: https://github.com/jedi4ever
[@jeffbyrnes]: https://github.com/jeffbyrnes
[@jimdaga]: https://github.com/jimdaga
[@jmanero-r7]: https://github.com/jmanero-r7
[@jpcallanta]: https://github.com/jpcallanta
[@jridgewell]: https://github.com/jridgewell
[@jschirle73]: https://github.com/jschirle73
[@jtimberman]: https://github.com/jtimberman
[@juliandunn]: https://github.com/juliandunn
[@julien-lebot]: https://github.com/julien-lebot
[@jvrplmlmn]: https://github.com/jvrplmlmn
[@k2v]: https://github.com/k2v
[@kbogtob]: https://github.com/kbogtob
[@kevinconaway]: https://github.com/kevinconaway
[@khouse]: https://github.com/khouse
[@kindlyseth]: https://github.com/kindlyseth
[@krasnoukhov]: https://github.com/krasnoukhov
[@kurochan]: https://github.com/kurochan
[@kylegoch]: https://github.com/kylegoch
[@lefthand]: https://github.com/lefthand
[@martinisoft]: https://github.com/martinisoft
[@mattrobenolt]: https://github.com/mattrobenolt
[@mfischer-zd]: https://github.com/mfischer-zd
[@mhebbar1]: https://github.com/mhebbar1
[@mikelaning]: https://github.com/mikelaning
[@miketheman]: https://github.com/miketheman
[@mikezhu-dd]: https://github.com/mikezhu-dd
[@mirceal]: https://github.com/mirceal
[@mlcooper]: https://github.com/mlcooper
[@moisesbotarro]: https://github.com/moisesbotarro
[@mstepniowski]: https://github.com/mstepniowski
[@mtougeron]: https://github.com/mtougeron
[@nicholas-devlin]: https://github.com/nicholas-devlin
[@nickmarden]: https://github.com/nickmarden
[@nilskuehme]: https://github.com/nilskuehme
[@nkts]: https://github.com/nkts
[@nyanshak]: https://github.com/nyanshak
[@olivielpeau]: https://github.com/olivielpeau
[@opsline-radek]: https://github.com/opsline-radek
[@otterdude97]: https://github.com/otterdude97
[@p-lambert]: https://github.com/p-lambert
[@phlipper]: https://github.com/phlipper
[@qqfr2507]: https://github.com/qqfr2507
[@raycrawford]: https://github.com/raycrawford
[@remeh]: https://github.com/remeh
[@remh]: https://github.com/remh
[@remicalixte]: https://github.com/remicalixte
[@rlaveycal]: https://github.com/rlaveycal
[@rposborne]: https://github.com/rposborne
[@rsheyd]: https://github.com/rsheyd
[@ryandjurovich]: https://github.com/ryandjurovich
[@schisamo]: https://github.com/schisamo
[@sethrosenblum]: https://github.com/sethrosenblum
[@shang-wang]: https://github.com/shang-wang
[@skarlupka]: https://github.com/skarlupka
[@someara]: https://github.com/someara
[@spencermpeterson]: https://github.com/spencermpeterson
[@stefanwb]: https://github.com/stefanwb
[@stensonb]: https://github.com/stensonb
[@stolfi]: https://github.com/stolfi
[@stonith]: https://github.com/stonith
[@swalberg]: https://github.com/swalberg
[@takus]: https://github.com/takus
[@tejom]: https://github.com/tejom
[@thisismana]: https://github.com/thisismana
[@timusg]: https://github.com/timusg
[@tmichelet]: https://github.com/tmichelet
[@truthbk]: https://github.com/truthbk
[@tymartin-novu]: https://github.com/tymartin-novu
[@uzyexe]: https://github.com/uzyexe
[@wk8]: https://github.com/wk8
[@wolf31o2]: https://github.com/wolf31o2
[@xt99]: https://github.com/xt99
[@yannmh]: https://github.com/yannmh
[@zshenker]: https://github.com/zshenker
