define mottainai::agent (
  String $application_url,
  String $agent_key,
  String $default_queue,
  String $exchange_queue,
  String $result_backend,
  String $broker,
  String $build_path,
  String $work_dir,
  Integer $agent_concurrency,
  Enum['present','absent'] $ensure = 'present',
) {

  file { "/etc/mottainai/mottainai-agent.yaml":
    ensure  => $ensure,
    content => epp('mottainai/mottainai-agent.epp', {
     application_url => $application_url,
     agent_key => $agent_key,
     default_queue => $default_queue,
     exchange_queue => $exchange_queue,
     result_backend => $result_backend,
     broker => $broker,
     build_path => $build_path,
     work_dir => $work_dir,
     agent_concurrency => $agent_concurrency,
    }),
    notify  => Service["mottainai-agent.service"],
  }

  service { "mottainai-agent.service":
    ensure  => if $ensure { 'running' } else { 'stopped' },
    enable  => if $ensure { true } else { false },
    require => File["/etc/mottainai/mottainai-agent.yaml"],
  }

  package {
    'dev-util/mottainai-agent':
      ensure => installed
  }

}
