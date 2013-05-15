package Koala::Model::Base;
use Koala::Model::Config;
use base qw/Rose::DB::Object/;

sub init_db { Koala::Model::Config->new() }

1;
