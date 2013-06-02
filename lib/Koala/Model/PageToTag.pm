package Koala::Model::PageToTag;
use base 'Koala::Model::Base';

__PACKAGE__->meta->setup(
  table => 'page_to_tag',
  columns => [
    id      => { type => 'int', primary_key => 1 },
    page_id => { type => 'int' },
    tag_id  => { type => 'int' },
  ],
  unique_key => ['page_id', 'tag_id'],
  foreign_keys => [
    page => {
      class => 'Koala::Model::Page',
      key_columns => { page_id => 'id' },
    },
    tag => {
      class => 'Koala::Model::Tag',
      key_columns => { tag_id => 'id' },
    },
  ],
);

# Manager for PageToTag Model
package Koala::Model::PageToTag::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'Koala::Model::PageToTag' }

__PACKAGE__->make_manager_methods( 'pages_to_tags' );

1;

__END__

=pod

=head1 DATABASE STRUCTURE

=head2 MySQL

  CREATE TABLE IF NOT EXISTS `page_to_tag` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `page_id` int(11) unsigned NOT NULL,
    `tag_id` int(11) unsigned NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_tag` (`page_id`,`tag_id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

=cut
