package Koala::Controller::Access;
use Mojo::Base 'Mojolicious';

sub user {
  my $self = shift;
  return 1 if $self->user->isUser();
  return 0;
}

sub staff {
  my $self = shift;
  return 1 if $self->user->isStaff();
  return 0;
}

sub admin {
  my $self = shift;
  return 1 if $self->user->isAdmin();
  return 0;
}

1;