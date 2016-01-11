class system ($user,$project_dir) {
  include apt

  class { 'python':
    version    => 'system',
    dev        => true,
    pip        => true,
    virtualenv => true,
  }
}
