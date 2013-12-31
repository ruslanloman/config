class openstack_project::add_user (
    $user_name = 'test',
    $group = 'test',
){
group { $group:
ensure => present,
}

user { $user_name:
ensure => present,
home => "/home/${user_name}",
groups => $group,
shell => '/bin/bash',
require => Group["${group}"],
}

file { 'home_dir':
path => "/home/${user_name}",
ensure => directory,
before => User["$user_name"],
}

exec { 'change_mode':
command => "chown ${user_name}:${user_name} -Rf /home/${user_name}",
path => $path,
require => File['home_dir'],
}

file { 'ssh_dir':
ensure => directory,
path => "/home/${user_name}/.ssh",
mode => '0600',
owner => $user_name,
group => $user_name,
require => User["${user_name}"],
}

file { "/home/${user_name}/.ssh/authorized_keys":
ensure => present,
mode => '0600',
owner => $user_name,
group => $user_name,
source => "puppet:///modules/openstack_project/add_user/id_rsa.pub",
require => File['ssh_dir'],
}
}
