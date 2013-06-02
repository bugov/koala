package Koala::Model::Tag;
use base 'Koala::Model::Base';

__PACKAGE__->meta->setup(
  table => 'tag',
  columns => [
    id          => { type => 'serial' , not_null => 1 },
    url         => { type => 'varchar', not_null => 1, length => 64 },
    title       => { type => 'varchar', not_null => 1, length => 64 },
    legend      => { type => 'varchar', not_null => 1, length => 255 },
  ],
  pk_columns => 'id',
  unique_key => 'url',
  unique_key => 'title',
);

__PACKAGE__->meta->add_relationship(
  pages => {
    type      => 'many to many',
    map_class => 'Koala::Model::PageToTag',
  },
);

#__PACKAGE__->meta->initialize;

# Manager for Tag Model
package Koala::Model::Tag::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'Koala::Model::Tag' }

__PACKAGE__->make_manager_methods( 'tags' );

1;

__END__

=pod

=head1 DATABASE STRUCTURE

=head2 MySQL

  CREATE TABLE IF NOT EXISTS `tag` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `url` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `title` varchar(64) NOT NULL,
    `legend` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `url` (`url`,`title`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

=cut
