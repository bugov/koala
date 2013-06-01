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

__END__

=pod

=head1 DATABASE STRUCTURE

=head2 MySQL

  CREATE TABLE IF NOT EXISTS `file` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `author_id` int(11) unsigned NOT NULL,
    `create_at` int(11) unsigned NOT NULL,
    `title` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `path` varchar(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
    `size` int(11) unsigned DEFAULT NULL,
    `mime_type` varchar(16) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `path` (`path`)
  ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

=cut
