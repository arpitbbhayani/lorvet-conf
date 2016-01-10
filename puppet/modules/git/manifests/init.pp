class git(
    $urlformat = 'https://github.com/%s.git',
    $user_name = undef,
    $user_email = undef,
    $github_oauth = undef,
) {

    package { 'git':
        ensure => latest,
    }

    exec { 'netrc configuration':
        command     => "echo 'machine github.com\n\tlogin ${github_oauth}\n\tpassword x-oauth-basic' >> /home/${base::user}/.netrc",
        user        => $base::user,
        group       => $base::user,
        environment => "HOME=/home/${base::user}",
        cwd         => "/home/${base::user}",
        unless      => "grep \"machine github.com\" \"/home/${base::user}/.netrc\""
    }

}
