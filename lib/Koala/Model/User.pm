package Koala::Model::User;
use base 'Koala::Model::Base', 'Koala::Entity::UserMixin';

__PACKAGE__->meta->setup(
  table => 'user',
  columns => [
    id       => { type => 'serial' , not_null => 1 },
    username => { type => 'varchar', length => 32 },
    email    => { type => 'varchar', not_null => 1, length => 64 },
    password => { type => 'varchar', not_null => 1, length => 40 },
    role     => { type => 'varchar', length => 32, default => 'user' },
    createAt => { type => 'integer', not_null => 1 },
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
