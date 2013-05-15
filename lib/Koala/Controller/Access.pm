package Koala::Controller::Access;
use Mojo::Base 'Mojolicious';

sub user {
  my $self = shift;
  return 1 if $self->user->is_user();
  return 0;
}

sub staff {
  my $self = shift;
  return 1 if $self->user->is_staff();
  return 0;
}

sub admin {
  my $self = shift;
  return 1 if $self->user->is_admin();
  return 0;
}

1;