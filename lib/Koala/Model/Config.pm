package Koala::Model::Config;
use base 'Rose::DB';
use Koala::Entity::Config;

$config = Koala::Entity::Config->new->get_config->{database};

__PACKAGE__->use_private_registry;
__PACKAGE__->default_connect_options( mysql_enable_utf8 => 1 );
__PACKAGE__->register_db ($config);

1;
