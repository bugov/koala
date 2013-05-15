package Koala::Model::Config;
use base 'Rose::DB';

__PACKAGE__->use_private_registry;
__PACKAGE__->default_connect_options( mysql_enable_utf8 => 1 );
__PACKAGE__->register_db (
  driver   => 'MySQL',
  database => 'koala',
  host     => 'localhost',
  username => 'koala',
  password => 'koala'
);

1;
