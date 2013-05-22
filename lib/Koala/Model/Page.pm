package Koala::Model::Page;
use base 'Koala::Model::Base';

__PACKAGE__->meta->setup(
  table => 'page',
  columns => [
    id          => { type => 'serial' , not_null => 1 },
    url         => { type => 'varchar', length => 64 },
    title       => { type => 'varchar', not_null => 1, length => 64 },
    legend      => { type => 'varchar', not_null => 1, length => 255 },
    picture_id  => { type => 'varchar', length => 64 },
    status      => { type => 'integer' },
    create_at   => { type => 'integer', not_null => 1 },
    modify_at   => { type => 'integer', not_null => 1 },
    keywords    => { type => 'varchar', not_null => 1, length => 255 },
    description => { type => 'varchar', not_null => 1, length => 512 },
    text        => { type => 'text', default => '' },
    author_id   => { type => 'integer' },
    approver_id => { type => 'integer' },
    owner_id    => { type => 'integer' },
  ],
  pk_columns => 'id',
  unique_key => 'url',
  unique_key => 'title',
  
  foreign_keys => [
    author => {
      class => 'Koala::Model::User',
      key_columns => { author_id => 'id'},
    },
    approver => {
      class => 'Koala::Model::User',
      key_columns => { approver_id => 'id'},
    },
    owner => {
      class => 'Koala::Model::User',
      key_columns => { owner_id => 'id'},
    },
    picture => {
      class => 'Koala::Model::File',
      key_columns => { picture_id => 'id'},
    },
  ],
);


# Var: possible_status
#   Enum for statuses

our %possible_status = (
  'deleted' => 0,
  'new'     => 10,
  'closed'  => 50,  # No comments, but visible
  'opened'  => 60,  # Comments are opened, visible
);


sub is_opened {
  my $self = shift;
  return 1 if $self->status >= $possible_status{'opened'};
  return 0;
}


# Method: set_status
#   set status by name
# Parameter: status - Str

sub set_status {
  my ($self, $status) = @_;
  die "Undefined status $status" unless exists $possible_status{$status};
  $self->status($status);
}

# Manager for User Model

package Koala::Model::Page::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'Koala::Model::Page' }

__PACKAGE__->make_manager_methods( 'pages' );

1;

__END__

=pod

=head1 Database structure

  CREATE TABLE IF NOT EXISTS `page` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `url` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `title` varchar(64) NOT NULL,
    `legend` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `picture` varchar(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
    `status` int(10) unsigned NOT NULL,
    `create_at` int(11) unsigned DEFAULT NULL,
    `modify_at` int(11) unsigned DEFAULT NULL,
    `keywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `description` varchar(512) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `text` text CHARACTER SET utf8 COLLATE utf8_bin,
    `author_id` int(11) unsigned NOT NULL,
    `approver_id` int(11) unsigned DEFAULT NULL,
    `owner_id` int(11) unsigned DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `url` (`url`)
  ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

=cut
