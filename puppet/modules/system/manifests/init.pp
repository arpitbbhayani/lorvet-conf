class system ($user,$project_dir) {
  include apt

  class { 'python':
    version    => 'system',
    dev        => 'present',
    pip        => 'present',
    virtualenv => 'present',
  }
}
