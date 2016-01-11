class bot (
  $repo_root       = "${system::project_dir}/lorvet-bot",
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

}
