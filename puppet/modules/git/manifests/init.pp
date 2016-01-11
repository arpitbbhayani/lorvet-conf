class git(
    $urlformat = 'https://github.com/%s.git',
    $user_name = undef,
    $user_email = undef,
    $github_oauth = undef,
) {

    package { 'git':
        ensure => latest,
    }

    exec { 'github.com in known hosts':
        command     => 'ssh-keyscan -H github.com >> $HOME/.ssh/known_hosts',
        unless      => 'ssh-keygen -F github.com',
        user        => $system::user,
        environment => "HOME=/home/${system::user}",
    }

    exec { 'netrc configuration':
        command     => "echo 'machine github.com\n\tlogin ${github_oauth}\n\tpassword x-oauth-basic' >> /home/${system::user}/.netrc",
        user        => $system::user,
        group       => $system::user,
        environment => "HOME=/home/${system::user}",
        cwd         => "/home/${system::user}",
        unless      => "grep \"machine github.com\" \"/home/${system::user}/.netrc\""
    }

}
