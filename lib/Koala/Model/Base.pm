package Koala::Model::Base;
use Koala::Model::Config;
use base 'Rose::DB::Object';
use Data::Dumper;

sub init_db { Koala::Model::Config->new() }

sub to_h {
  my ($self, @data) = shift;
  push @data, $_ => $self->{$_} for $self->meta->column_names;
  return {@data};
}

1;
