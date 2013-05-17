package Koala::Model::Category;
use base 'Koala::Model::Base';

__PACKAGE__->meta->setup(
  table => 'category',
  columns => [
    id          => { type => 'serial' , not_null => 1 },
    url         => { type => 'varchar', length => 64 },
    title       => { type => 'varchar', not_null => 1, length => 64 },
    legend      => { type => 'varchar', not_null => 1, length => 255 },
    picture     => { type => 'varchar', length => 64 },
  ],
  pk_columns => ['url', 'id'],
  unique_key => 'title',
);

# Manager for Category Model

package Koala::Model::Category::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'Koala::Model::Category' }

__PACKAGE__->make_manager_methods( 'categories' );

1;