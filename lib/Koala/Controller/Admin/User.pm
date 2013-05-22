package Koala::Controller::Admin::User;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::User;

my $list_size = 20;

sub list {
  my $self = shift;
  my $page = int $self->param('page');
  my $user_list = Koala::Model::User::Manager->get_users(
    sort_by => 'id', limit => $list_size,
    offset => $list_size * ($page-1)
  );
  my $user_count = Koala::Model::User::Manager->get_users_count();
  $self->render('user/admin/list', user_list => $user_list, user_count => $user_count, limit => $list_size);
}

sub show {
  my $self = shift;
  my $user = Koala::Model::User->new(id => int $self->param('id'))->load();
  $self->render('user/admin/show', user => $user);
}

sub edit {
  my $self = shift;
  my $user = Koala::Model::User->new(id => int $self->param('id'))->load();
  $user->$_($self->param($_)) for qw/username email info role/;
  $user->create_at( $self->dt($self->param('create_at')) );
  $user->new_password($self->param('password')) if $self->param('password');
  $user->save();
  $self->flash({message => 'Profile edited', type => 'success'})
    ->redirect_to('admin_user_show');
}

1;