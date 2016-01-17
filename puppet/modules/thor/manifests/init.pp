class thor (
  $repo_root = "${system::project_dir}/thor",
  $user      = $system::user,
) {

    include mysql::server
    include mysql::client

    mysql::db { 'thor':
      user     => 'thor',
      password => 'thor',
    }
}
