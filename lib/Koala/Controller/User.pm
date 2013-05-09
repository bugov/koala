package Koala::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::User;

sub login {
  my $self = shift;
  my $user = Koala::Model::User->new(username => $self->param('username'))->load;
  if ($user->testPassword($self->param('password'))) {
    return $self->session($user->getSessionData())->redirect_to('user_home')
  }
  $self->redirect_to('user_login_form');
}

sub reg {
  my $self = shift;
  my $user = Koala::Model::User->new(
    username => $self->param('username'),
    email => $self->param('email'),
    createAt => time
  );
  $user->newPassword($self->param('password'));
  $user->save();
  $self->redirect_to('user_login_form');
}

sub home {
  my $self = shift;
  my $user = eval{Koala::Model::User->new(id => $self->session('id'))->load};
  return $self->render(user => $user) unless $@;
  return $self->render(template => 'not_found', code => 401);
}

sub logout {
  my $self = shift;
  $self->session(userId => 0)->redirect_to('user_login_form');
}

1;