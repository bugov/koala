package Koala::Model::PageToTag;
use base 'Rose::DB::Object';

__PACKAGE__->meta->table('page_to_tag');
__PACKAGE__->meta->columns(
  id      => { type => 'int', primary_key => 1 },
  page_id => { type => 'int' },
  tag_id  => { type => 'int' },
);

__PACKAGE__->meta->foreign_keys(
  page => {
    class => 'Koala::Model::Page',
    key_columns => { page_id => 'id' },
  },

  tag => {
    class => 'Koala::Model::Tag',
    key_columns => { tag_id => 'id' },
  },  
);

__PACKAGE__->meta->initialize;

1;

__END__

=pod

=head1 DATABASE STRUCTURE

=head2 MySQL

  CREATE TABLE IF NOT EXISTS `page_to_tag` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `page_id` int(11) unsigned NOT NULL,
    `tag_id` int(11) unsigned NOT NULL,
    PRIMARY KEY (`id`)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

=cut
