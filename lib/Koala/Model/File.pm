package Koala::Model::File;
use base 'Koala::Model::Base';

__PACKAGE__->meta->setup(
  table => 'file',
  columns => [
    id          => { type => 'serial' , not_null => 1 },
    author_id   => { type => 'integer' },
    create_at   => { type => 'integer' },
    title       => { type => 'varchar', not_null => 1, length => 64 },
    path        => { type => 'varchar', not_null => 1, length => 64 },
    size        => { type => 'integer' },
    mime_type   => { type => 'varchar', length => 16 },
  ],
  pk_columns => 'id',
  
  foreign_keys => [
    author => {
      class => 'Koala::Model::User',
      key_columns => { author_id => 'id'},
    },
  ],
);

# Manager for File Model
package Koala::Model::File::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'Koala::Model::File' }

__PACKAGE__->make_manager_methods( 'files' );

1;