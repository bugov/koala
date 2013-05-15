package Koala::Controller::Page;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Page;

sub show {
  my $self = shift;
  my ($url, $id) = ($self->param('url'), $self->param('id'));
  my $page = Koala::Model::Page->new(id => $id)->load();
  $self->render(page => $page);
}

1;