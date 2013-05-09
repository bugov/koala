package Koala;
use Mojo::Base 'Mojolicious';
use Koala::Entity::User;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  $self->addHelpers();

  # Router
  my $r = $self->routes;
  # Access
  my $user  = $r->bridge('/user' )->to('access#user' , namespace => 'Koala::Controller');
  my $staff = $r->bridge('/staff')->to('access#staff', namespace => 'Koala::Controller');
  my $admin = $r->bridge('/admin')->to(cb => sub {shift->user->isAdmin() ? 1 : 0});
  # User
  my $u = $r->route('user')->to('user#', namespace => 'Koala::Controller');
    $u    ->get ('login') ->to('#login_form')->name('user_login_form');
    $u    ->post('login') ->to('#login')     ->name('user_login');
    $u    ->get ('reg')   ->to('#reg_form')  ->name('user_reg_form');
    $u    ->post('reg')   ->to('#reg')       ->name('user_reg');
    $user ->get ('home')  ->to('#home')      ->name('user_home');
    $user ->get ('logout')->to('#logout')    ->name('user_logout');
  # User Admin
  $u = $admin->route('user')->to('user#', namespace => 'Koala::Controller::Admin');
    $u->get ('list')->to('#list')->name('admin_user_list');
    $u->get (':id') ->to('#show')->name('admin_user_show');
    $u->post(':id') ->to('#edit')->name('admin_user_edit');
  
  # Pages
  my $p = $r->route()->to('page#', namespace => 'Koala::Controller');
    $p->get(':url/:id')->to('#show')->name('page_show');
  
}

sub addHelpers {
  my $self = shift;
  
  $self->helper('user' => sub {
    my $self = shift;
    return Koala::Entity::User->new->init(
      id => $self->session('id'),
      username => $self->session('username'),
      email => $self->session('email'),
      role => $self->session('role'),
    );
  });
}

1;
