define git::update_or_clone($directory, $remote=undef) {
  include git

  $url = $remote ? {
    undef   => sprintf($git::urlformat, $title),
    default => $remote,
  }

  exec { "git clone ${title}":
    command     => "git clone ${url} ${directory}",
    creates     => "${directory}/.git/refs/remotes",
    require     => [Package['git'],
                    Exec['github.com in known hosts'],
                    ],
    user        => $system::user,
    environment => "HOME=/home/${system::user}",
    timeout     => 0,
  }
  ->
  exec { "git update ${title}":
    command     => 'git pull origin master',
    cwd         => $directory,
    onlyif      => 'test "master" = "$(git rev-parse --abbrev-ref HEAD)" -a 0 -eq $(git diff | wc -l) && git fetch origin && test "$(git rev-parse master)" != "$(git rev-parse origin/master)"',
    user        => $system::user,
    environment => "HOME=/home/${system::user}",
    timeout     => 0,
  }

  exec { "${title} is not running master":
    command => 'test "master" = "$(git rev-parse --abbrev-ref HEAD)"',
    cwd     => $directory,
    unless  => 'test "master" = "$(git rev-parse --abbrev-ref HEAD)"',
    require => Exec["git clone ${title}"],
  }

  exec { "${title} has local changes":
    command => 'test 0 -eq $(git diff | wc -l)',
    cwd     => $directory,
    unless  => 'test 0 -eq $(git diff | wc -l)',
    require => Exec["git clone ${title}"],
  }
}
