package Koala::Model::Comment;
use base 'Koala::Model::Base';

__PACKAGE__->meta->setup(
  table => 'comment',
  columns => [
    id          => { type => 'serial' , not_null => 1 },
    page_id     => { type => 'integer', not_null => 1 },
    status      => { type => 'integer' },
    create_at   => { type => 'integer' },
    title       => { type => 'varchar', not_null => 1, length => 64 },
    author_id   => { type => 'integer' },
    username    => { type => 'varchar', not_null => 1, length => 64 },
    text        => { type => 'text', default => '' },
  ],
  pk_columns => 'id',
  
  foreign_keys => [
    author => {
      class => 'Koala::Model::User',
      key_columns => { author_id => 'id'},
    },
    page => {
      class => 'Koala::Model::Page',
      key_columns => { page_id => 'id'},
    },
  ],
);

# Manager for Comment Model
package Koala::Model::Comment::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'Koala::Model::Comment' }

__PACKAGE__->make_manager_methods( 'comments' );

1;

__END__

=pod

=head1 DATABASE STRUCTURE

=head2 MySQL

  CREATE TABLE IF NOT EXISTS `comment` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `page_id` int(10) unsigned NOT NULL,
    `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
    `create_at` int(11) unsigned NOT NULL,
    `title` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
    `author_id` int(11) unsigned DEFAULT NULL,
    `username` varchar(64) CHARACTER SET utf8 NOT NULL DEFAULT 'Guest',
    `text` text CHARACTER SET utf8 NOT NULL,
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

=cut
