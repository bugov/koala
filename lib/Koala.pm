package Koala;
use Mojo::Base 'Mojolicious';
use DateTime;
use DateTime::Format::MySQL;
use Mojo::ByteStream;
use Koala::Entity::User;
use Koala::Model::User;
use Koala::Model::Category;
use Koala::Model::Tag;
use Koala::Entity::Config;
use FindBin;

# This method will run once at server start
sub startup {
  my $self = shift;
  
  # Include blog's template.
  my $config = Koala::Entity::Config->new->get_config->{blog};
  $self->renderer->paths([
    $FindBin::Bin.'/../templates/custom/'.$config->{template},
    $FindBin::Bin.'/../templates/default'
  ]);
  $self->static->paths([
    $FindBin::Bin.'/../public/custom/'.$config->{template},
    $FindBin::Bin.'/../public/default',
    $FindBin::Bin.'/../public/upload',
  ]);
  
  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  $self->addHelpers();

  # Router
  my $r = $self->routes;
    $r->route(':page', page => qr/\d*/)->to('page#list', page => 1, namespace => 'Koala::Controller');
  
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
    $u->get ('list/:page')->to('#list', page => 1)->name('admin_user_list');
    $u->get (':id')->to('#show')->name('admin_user_show');
    $u->post(':id')->to('#edit')->name('admin_user_edit');
  
  # Page & comments
  $r->post('page/:id/comment')->to('comment#create', namespace => 'Koala::Controller')->name('page_comment');
  $r->get('page/:id/comment/load')->to('comment#load', namespace => 'Koala::Controller')->name('page_comment_load');
  # Page & comments for Admins
  my $p = $admin->route('page')->to('page#', namespace => 'Koala::Controller::Admin');
    $p->get ('comments/:page')->to('comment#list', page => 1)->name('admin_comment_list');
    $p->get ('comments/delete/:id')->to('comment#delete')->name('admin_comment_delete');
    $p->post('comments/:id')->to('comment#edit')->name('admin_comment_edit');
    $p->get ('list/:page')->to('#list', page => 1)->name('admin_page_list');
    $p->get ('new') ->to(template => 'page/admin/form')->name('admin_page_create_form');
    $p->post('new') ->to('#create')->name('admin_page_create');
    $p->get (':id') ->to('#show')->name('admin_page_show');
    $p->post(':id') ->to('#edit')->name('admin_page_edit');
    $p->get ('comment/:id')->to('comment#show')->name('admin_comment_show');
    $p->post('picture/crop/:id')->to('#picture_crop')->name('admin_page_picture_crop');
  # Category for Admins
  my $c = $admin->route('category')->to('category#', namespace => 'Koala::Controller::Admin');
    $c->get ('list/:page')->to('#list', page => 1)->name('admin_category_list');
    $c->get ('new') ->to(template => 'category/admin/form')->name('admin_category_create_form');
    $c->post('new') ->to('#create')->name('admin_category_create');
    $c->get (':id') ->to('#show')->name('admin_category_show');
    $c->post(':id') ->to('#edit')->name('admin_category_edit');
  # Tag for Admins
  my $t = $admin->route('tag')->to('tag#', namespace => 'Koala::Controller::Admin');
    $t->get ('list/:page')->to('#list', page => 1)->name('admin_tag_list');
    $t->get ('new') ->to(template => 'tag/admin/form')->name('admin_tag_create_form');
    $t->post('new') ->to('#create')->name('admin_tag_create');
    $t->get (':id') ->to('#show')->name('admin_tag_show');
    $t->post(':id') ->to('#edit')->name('admin_tag_edit');
  # File
  my $f = $r->route('file')->to('file#', namespace => 'Koala::Controller');
    $f->post('upload')->to('#upload')->name('file_upload');
    
  # Show Page
  $r->get('*url')->to('page#show', namespace => 'Koala::Controller')->name('page_show');
  
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
    my ($self, $time, $format) = @_;
    
    my $reformat = sub {
      my ($dt, $fmt) = @_;
      
      given ($fmt) {
        when ('dd.mm.yy') {
          my $d = $dt->day   < 10 ? '0'.$dt->day   : $dt->day;
          my $m = $dt->month < 10 ? '0'.$dt->month : $dt->month;
          my $y = substr $dt->year, 2;
          return "$d.$m.$y";
        }
        default { return "Invalid format" }
      }
    };
    
    # current time
    if (!defined $time) {
      my $dt = DateTime->now();
      return ( $format
                ? $reformat->($dt, $format)
                : DateTime::Format::MySQL->format_datetime($dt) );
    }
    # show time
    elsif ($time =~ /^\d+$/) {
      my $dt = DateTime->from_epoch(epoch => $time);
      return ( $format
                ? $reformat->($dt, $format)
                : DateTime::Format::MySQL->format_datetime($dt) );
    }
    # get time from string
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
      $self->render('user/helper/role_list', partial => 1,
        role_list => $self->user->roles, default => int $default)
    )
  });
  
  $self->helper('category_list' => sub {
    my ($self, $default) = @_;
    $default ||= 1;
    my $category_list = Koala::Model::Category::Manager->get_categories();
    return Mojo::ByteStream->new(
      $self->render('category/helper/category_list', partial => 1,
        list => $category_list, default => int $default)
    );
  });
  
  $self->helper('status_list' => sub {
    my ($self, $default) = @_;
    my $list = { %Koala::Model::Page::possible_status };
    $default = $list->{$default} unless $default =~ /^\d+$/;
    return Mojo::ByteStream->new(
      $self->render('page/helper/status_list', partial => 1,
        status_list => $list, default => int $default)
    );
  });
  
  $self->helper('category_links' => sub {
    my ($self, $category_id) = @_;
    my $list = Koala::Model::Category::Manager->get_categories();
    return Mojo::ByteStream->new(
      $self->render('category/helper/category_links', partial => 1, list => $list)
    );
  });
  
  $self->helper('tag_links' => sub {
    my ($self, $tag_id) = @_;
    my $list = Koala::Model::Tag::Manager->get_tags();
    return Mojo::ByteStream->new(
      $self->render('tag/helper/tag_links', partial => 1, list => $list)
    );
  });
  
  $self->helper('paginator' => sub {
    # Helper: paginator
    #   Paginator (what do you expect to see here?)
    # Parameters:
    #   self        Mojolicious::Controller (I thought)
    #   url_name    Str Mojolicious::Routes::Route's name
    #   cur         Int current page number
    #   count       Int count of items
    #   size        Int like sql limit
    #   params      ArrayRef Mojolicious::Routes::Route's  params
    # Return: Mojo::ByteStream paginator's html
    
    my ($self, $url_name, $cur, $count, $size, $params) = @_;
    my $html = '';
    return '' if not defined $count or $count <= $size;
    
    my $last = int ( $count / $size );
    ++$last if $count % $size;
    
    # Render first page.
    $html .= sprintf '<a href="%s">&laquo;</a>',
      $self->url_for($url_name, page => 1) if $cur != 1;
    
    for my $i ($cur-5 .. $cur+5) {
      next if $i < 1 || $i > $last;
      $params = [] unless defined $params;
      $html .= ($i == $cur ? sprintf '<span>%s</span>', $cur :
        sprintf '<a href="%s">%s</a>', $self->url_for($url_name, @$params, page => $i), $i);
    }
    
    # Render last page.
    $html .= sprintf '<a href="%s">&raquo;</a>', $self->url_for($url_name, page => $last) if $cur != $last;
    
    Mojo::ByteStream->new("<div class=\"paginator\">$html</div>");
  });
  
  $self->helper('error_json' => sub {
    my $self = shift;
    my %data = (code => 500, @_);
    return $self->render(json => \%data);
  });
  
  $self->helper('not_found' => sub {
    my $self = shift;
    return $self->render(template => 'not_found', code => 404);
  });
  
  $self->helper('not_found_json' => sub {
    my $self = shift;
    return $self->render(json => {error => 404, code => 404, 'message' => 'Page not found'});
  });
  
  $self->helper('crlf' => sub {
    my $self = shift;
    my ($text) = @_;
    $text =~ s/</&lt;/g;
    $text =~ s/>/&gt;/g;
    $text =~ s/\r?\n/<br>/g;
    return Mojo::ByteStream->new($text);
  });
}

1;
