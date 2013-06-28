package Koala::Model::Config;
use base 'Rose::DB';
use FindBin;
use JSON::XS;
use Data::Dumper;

my $config;
{
  open(my $fh, "$FindBin::Bin/../conf/database.json")
    or die "Can't find $FindBin::Bin/../conf/database.json";
  local $/;
  $config = <$fh>;
  close $fh;
}
$config = decode_json $config;

__PACKAGE__->use_private_registry;
__PACKAGE__->default_connect_options( mysql_enable_utf8 => 1 );
__PACKAGE__->register_db ($config->{database});

1;
