Changes
=======

# 2.4.0 / Unreleased

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
[#272]: https://github.com/DataDog/chef-datadog/issues/272
[#273]: https://github.com/DataDog/chef-datadog/issues/273
[#274]: https://github.com/DataDog/chef-datadog/issues/274
[#276]: https://github.com/DataDog/chef-datadog/issues/276
[#277]: https://github.com/DataDog/chef-datadog/issues/277
[#278]: https://github.com/DataDog/chef-datadog/issues/278
[#280]: https://github.com/DataDog/chef-datadog/issues/280
[#281]: https://github.com/DataDog/chef-datadog/issues/281
[#285]: https://github.com/DataDog/chef-datadog/issues/285
[#286]: https://github.com/DataDog/chef-datadog/issues/286
[#294]: https://github.com/DataDog/chef-datadog/issues/294
[#295]: https://github.com/DataDog/chef-datadog/issues/295
[#296]: https://github.com/DataDog/chef-datadog/issues/296
[#298]: https://github.com/DataDog/chef-datadog/issues/298
[#299]: https://github.com/DataDog/chef-datadog/issues/299
[#300]: https://github.com/DataDog/chef-datadog/issues/300
[#304]: https://github.com/DataDog/chef-datadog/issues/304
[@ABrehm264]: https://github.com/ABrehm264
[@DorianZaccaria]: https://github.com/DorianZaccaria
[@EasyAsABC123]: https://github.com/EasyAsABC123
[@JoeDeVries]: https://github.com/JoeDeVries
[@LeoCavaille]: https://github.com/LeoCavaille
[@MiguelMoll]: https://github.com/MiguelMoll
[@NathanielMichael]: https://github.com/NathanielMichael
[@RedWhiteMiko]: https://github.com/RedWhiteMiko
[@SelerityMichael]: https://github.com/SelerityMichael
[@SupermanScott]: https://github.com/SupermanScott
[@alexism]: https://github.com/alexism
[@alq]: https://github.com/alq
[@antonio-osorio]: https://github.com/antonio-osorio
[@arthurnn]: https://github.com/arthurnn
[@babbottscott]: https://github.com/babbottscott
[@bitmonk]: https://github.com/bitmonk
[@chrissnell]: https://github.com/chrissnell
[@clofresh]: https://github.com/clofresh
[@cobusbernard]: https://github.com/cobusbernard
[@coosh]: https://github.com/coosh
[@ctrlok]: https://github.com/ctrlok
[@darron]: https://github.com/darron
[@datwiz]: https://github.com/datwiz
[@dlackty]: https://github.com/dlackty
[@dominicchan]: https://github.com/dominicchan
[@donaldguy]: https://github.com/donaldguy
[@drewrothstein]: https://github.com/drewrothstein
[@dwradcliffe]: https://github.com/dwradcliffe
[@elafarge]: https://github.com/elafarge
[@elijahandrews]: https://github.com/elijahandrews
[@evan2645]: https://github.com/evan2645
[@flah00]: https://github.com/flah00
[@graemej]: https://github.com/graemej
[@gregf]: https://github.com/gregf
[@hartfordfive]: https://github.com/hartfordfive
[@hilli]: https://github.com/hilli
[@hydrant25]: https://github.com/hydrant25
[@iashwash]: https://github.com/iashwash
[@inokappa]: https://github.com/inokappa
[@isaacdd]: https://github.com/isaacdd
[@jblancett]: https://github.com/jblancett
[@jedi4ever]: https://github.com/jedi4ever
[@jeffbyrnes]: https://github.com/jeffbyrnes
[@jmanero-r7]: https://github.com/jmanero-r7
[@jpcallanta]: https://github.com/jpcallanta
[@jridgewell]: https://github.com/jridgewell
[@jtimberman]: https://github.com/jtimberman
[@juliandunn]: https://github.com/juliandunn
[@khouse]: https://github.com/khouse
[@kindlyseth]: https://github.com/kindlyseth
[@kurochan]: https://github.com/kurochan
[@martinisoft]: https://github.com/martinisoft
[@mattrobenolt]: https://github.com/mattrobenolt
[@mfischer-zd]: https://github.com/mfischer-zd
[@miketheman]: https://github.com/miketheman
[@mirceal]: https://github.com/mirceal
[@mstepniowski]: https://github.com/mstepniowski
[@mtougeron]: https://github.com/mtougeron
[@nickmarden]: https://github.com/nickmarden
[@nkts]: https://github.com/nkts
[@olivielpeau]: https://github.com/olivielpeau
[@opsline-radek]: https://github.com/opsline-radek
[@phlipper]: https://github.com/phlipper
[@qqfr2507]: https://github.com/qqfr2507
[@remh]: https://github.com/remh
[@rlaveycal]: https://github.com/rlaveycal
[@ryandjurovich]: https://github.com/ryandjurovich
[@schisamo]: https://github.com/schisamo
[@sethrosenblum]: https://github.com/sethrosenblum
[@takus]: https://github.com/takus
[@tejom]: https://github.com/tejom
[@thisismana]: https://github.com/thisismana
[@timusg]: https://github.com/timusg
[@uzyexe]: https://github.com/uzyexe
[@wk8]: https://github.com/wk8
[@yannmh]: https://github.com/yannmh
[@zshenker]: https://github.com/zshenker
