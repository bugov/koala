package Koala::Controller::User;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::User;

sub login {
  my $self = shift;
  my $user = Koala::Model::User->new(username => $self->param('username'))->load;
  if ($user->test_password($self->param('password'))) {
    return $self->session($user->get_session_data())->redirect_to('user_home')
  }
  $self->redirect_to('user_login_form');
}

sub reg {
  my $self = shift;
  my $user = Koala::Model::User->new(
    username => $self->param('username'),
    email => $self->param('email'),
    create_at => time
  );
  $user->new_password($self->param('password'));
  $user->save();
  $self->redirect_to('user_login_form');
}

sub home {
  my $self = shift;
  my $user = eval{Koala::Model::User->new(id => $self->user->id)->load}
    or return $self->render(template => 'not_found', code => 401);
  return $self->render(user => $user);
}

sub logout {
  my $self = shift;
  $self->session(id => 0)->redirect_to('user_login_form');
}

1;