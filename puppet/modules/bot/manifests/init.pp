class bot (
  $repo_root = "${system::project_dir}/lorvet-bot",
  $user      = $system::user,
  $bot_token = 'xxx',
  $bot_id = 'xxx',
  $consumer_key = 'xxx',
  $consumer_secret = 'xxx',
  $access_token = 'xxx',
  $access_secret = 'xxx',
) {

    git::update_or_clone { 'arpitbbhayani/lorvet':
        directory => $repo_root,
  }

  ensure_packages(['supervisor'])

  python::virtualenv { "${repo_root}/venv":
    requirements => "${repo_root}/requirements.txt",
    owner        => $user,
    group        => $user,
    require      => [ Git::Update_Or_Clone['arpitbbhayani/lorvet'] ],
    path         => ['/usr/local/bin', '/usr/bin', '/bin'],
    cwd          => $repo_root,
    timeout      => 0,
  }

  file { "${repo_root}/config.ini":
    ensure  => file,
    content => template('bot/config.ini.erb'),
    require => Git::Update_Or_Clone['arpitbbhayani/lorvet'],
    notify  => Service['supervisor'],
    owner   => $system::user,
    group   => $system::user,
  }

  file { '/etc/supervisor/conf.d/lorvet-bot.conf':
    ensure  => file,
    content => template('bot/supervisor.conf.erb'),
    require => [Package['supervisor']],
    notify  => Exec['supervisor update'],
    before  => Service['supervisor'],
  }

  service { 'supervisor':
      ensure     => running,
      hasstatus  => true,
      hasrestart => false,
      require    => Package['supervisor'],
    }

  exec { 'supervisor update':
      command     => 'supervisorctl update',
      refreshonly => true,
      require     => Service['supervisor']
      }

}
