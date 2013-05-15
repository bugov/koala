package Koala;
use Mojo::Base 'Mojolicious';
use Koala::Entity::User;
use DateTime;
use DateTime::Format::MySQL;
use Mojo::ByteStream;
use Koala::Model::User;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  $self->addHelpers();

  # Router
  my $r = $self->routes;
  # Access
  my $user  = $r->bridge('/user' )->to(cb => sub {shift->user->is_user () ? 1 : 0});
  my $staff = $r->bridge('/staff')->to(cb => sub {shift->user->is_staff() ? 1 : 0});
  my $admin = $r->bridge('/admin')->to(cb => sub {shift->user->is_admin() ? 1 : 0});
  
  # User
  my $u = $r->route('user')->to('user#', namespace => 'Koala::Controller');
    $u->get ('login') ->to('#login_form')->name('user_login_form');
    $u->post('login') ->to('#login')     ->name('user_login');
    $u->get ('reg')   ->to('#reg_form')  ->name('user_reg_form');
    $u->post('reg')   ->to('#reg')       ->name('user_reg');
  # User for Users
  $u = $user->to('user#', namespace => 'Koala::Controller');
    $u->get ('home')  ->to('#home')  ->name('user_home');
    $u->get ('logout')->to('#logout')->name('user_logout');
  # User for Admins
  $u = $admin->route('user')->to('user#', namespace => 'Koala::Controller::Admin');
    $u->get ('list')->to('#list')->name('admin_user_list');
    $u->get (':id') ->to('#show')->name('admin_user_show');
    $u->post(':id') ->to('#edit')->name('admin_user_edit');
  
  # Page
  $r->get(':url/:id')->to('page#show', namespace => 'Koala::Controller')->name('page_show');
  # Page for Admins
  my $p = $admin->route('page')->to('page#', namespace => 'Koala::Controller::Admin');
    $p->get ('list')->to('#list')->name('admin_page_list');
    $p->get ('new') ->to(template => 'page/admin/form')->name('admin_page_create_form');
    $p->post('new') ->to('#create')->name('admin_page_create');
    $p->get (':id') ->to('#show')->name('admin_page_show');
    $p->post(':id') ->to('#edit')->name('admin_page_edit');
  
}

sub addHelpers {
  my $self = shift;
  
  $self->helper('user' => sub {
    # User session getter
    my $self = shift;
    return Koala::Entity::User->new->init(
      id => $self->session('id'),
      username => $self->session('username'),
      email => $self->session('email'),
      role => $self->session('role'),
    );
  });
  
  $self->helper('dt' => sub {
    # Format datetime
    my ($self, $time) = @_;
    
    if (!defined $time) {
      my $dt = DateTime->now();
      return DateTime::Format::MySQL->format_datetime($dt);
    }
    elsif ($time =~ /^\d+$/) {
      my $dt = DateTime->from_epoch(epoch => $time);
      return DateTime::Format::MySQL->format_datetime($dt);
    }
    elsif ($time =~ /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/) {
      my $dt = DateTime::Format::MySQL->parse_datetime($time);
      return $dt->epoch();
    }
  });
  
  $self->helper('user_list' => sub {
    # select user (html)
    my ($self, $role, $default, $html_name) = @_;
    $role = $self->user->roles->{$role};
    my $user_list = Koala::Model::User::Manager->get_users(where => [role => {ge => $role}]);
    return Mojo::ByteStream->new(
      $self->render('user/helper/user_list', partial => 1, default => int $default,
                    user_list => $user_list, html_name => $html_name)
    );
  });
  
  $self->helper('role_list' => sub {
    my ($self, $default) = @_;
    return Mojo::ByteStream->new(
      $self->render('user/helper/role_list', partial => 1, role_list => $self->user->roles, default => int $default)
    )
  });
  
  $self->helper('status_list' => sub {
    my ($self, $default) = @_;
    my $list = { %Koala::Model::Page::possible_status };
    $default = $list->{$default} unless $default =~ /^\d+$/;
    return Mojo::ByteStream->new(
      $self->render('page/helper/status_list', partial => 1,
        status_list => $list, default => int $default)
    )
  });
}

1;
