package Koala::Model::User;
use base 'Koala::Model::Base', 'Koala::Entity::UserMixin';

__PACKAGE__->meta->setup(
  table => 'user',
  columns => [
    id       => { type => 'serial' , not_null => 1 },
    username => { type => 'varchar', length => 32 },
    email    => { type => 'varchar', not_null => 1, length => 64 },
    password => { type => 'varchar', not_null => 1, length => 40 },
    role     => { type => 'integer', default => 50 }, # 50 is a user role
    create_at=> { type => 'integer', not_null => 1 },
    info     => { type => 'text', default => '' },
  ],
  pk_columns => 'id',
  unique_key => 'email',
  unique_key => 'username',
);

# Manager for User Model

package Koala::Model::User::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'Koala::Model::User' }

__PACKAGE__->make_manager_methods( 'users' );

1;

__END__

=pod

=head1 DATABASE STRUCTURE

=head2 MySQL

  CREATE TABLE IF NOT EXISTS `user` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `username` varchar(32) NOT NULL,
    `email` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `password` varchar(40) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `role` int(4) NOT NULL,
    `create_at` int(11) unsigned NOT NULL,
    `info` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `username` (`username`,`email`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

=cut
