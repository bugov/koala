package Koala::Model::Image;
use base 'Koala::Model::File';

__PACKAGE__->meta->setup(
  table => 'image',
  columns => [
    height      => { type => 'integer' },
    width       => { type => 'integer' },
  ],
);

# Manager for Image Model
package Koala::Model::Image::Manager;
use base 'Koala::Model::File::Manager';

sub object_class { 'Koala::Model::Image' }

__PACKAGE__->make_manager_methods( 'images' );

1;