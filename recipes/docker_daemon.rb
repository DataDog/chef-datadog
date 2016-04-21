include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @see https://www.datadoghq.com/2014/06/monitor-docker-datadog/
# @example
#   node.override['datadog']['docker_daemon']['init_config'] = {
#     docker_root: '/',
#     socket_timeout: 10,
#     tls: false,
#     tls_client_cert: '/path/to/client-cert.pem',
#     tls_client_key: '/path/to/client-key.pem',
#     tls_cacert: '/path/to/ca.pem',
#     tls_verify: true
#   }
#   node.override['datadog']['docker_daemon']['instances'] = [
#     {
#       url: 'unix://var/run/docker.sock',
#       tags: [
#         'toto',
#         'tata'
#       ],
#       include: [
#         'docker_image:ubuntu',
#         'docker_image:debian'
#       ],
#       exclude: [
#         '.*'
#       ],
#       performance_tags: [
#         'container_name',
#         'image_name',
#         'image_tag',
#         'docker_image'
#       ],
#       container_tags: [
#         'image_name',
#         'image_tag',
#         'docker_image'
#       ],
#       collect_labels_as_tags: [
#         'com.docker.compose.service',
#         'com.docker.compose.project'
#       ],
#       ecs_tags: true,
#       collect_events: true,
#       collect_container_size: false,
#       collect_image_size: false,
#       collect_images_stats: false
#     }
#   ]

datadog_monitor 'docker_daemon' do
  init_config node['datadog']['docker_daemon']['init_config']
  instances node['datadog']['docker_daemon']['instances']
end
