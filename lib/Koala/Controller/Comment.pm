package Koala::Controller::Comment;
use Mojo::Base 'Mojolicious::Controller';
use Net::Akismet;
use Koala::Model::Comment;
use Koala::Entity::Config;

my $size = 10;
my $default_status = 0; # closed, opened = 0, 1


sub create {
  my $self = shift;
  my $page = eval{Koala::Model::Page->new(id => int $self->param('id'))->load} or return $self->not_found_json;
  return $self->error_json(message => 'Comments closed') unless $page->is_opened();
  
  my %data = (
    author_id => $self->user->id,
    page_id   => $page->id,
    create_at => time,
    status    => $default_status,
    text      => $self->param('text'),
    title     => $self->param('title'),
    username  => $self->param('username'),
  );
  
  # Akismet
  $config = Koala::Entity::Config->init->get_config->{akismet};
  my $akismet = Net::Akismet->new(%$config) or die('Key verification failure!');
  my $fail = $akismet->check (
      USER_IP => $this->tx->remote_address,
      COMMENT_USER_AGENT => $this->req->headers->user_agent,
      COMMENT_CONTENT => $data{text},
      COMMENT_AUTHOR => $data{username},
      REFERRER => $this->req->headers->referrer,
#      COMMENT_AUTHOR_EMAIL => $this->user->{mail},
  ) or die('Is the Akismet server dead?');
  return $self->render(json => {error => 401, comment => 'Seems like spam...'}) if 'true' eq $fail;
  
  # Save & render
  Koala::Model::Comment->new(%data)->save;
  $self->render(json => {error => 0, comment => \%data});
}

# Load more comments
sub load {
  my $self = shift;
  my $id = $self->param('id');
  my $offset = $self->param('offset');
  my $comment_list = Koala::Model::Comment::Manager->get_comments(
    where => [page_id => $id, status => {gt => 0}], sort_by => '-id', limit => $size, offset => $offset);
  for my $c (0 .. $#$comment_list) {
    $comment_list->[$c] = $comment_list->[$c]->to_h;
    $comment_list->[$c]->{create_at} = $self->dt($comment_list->[$c]->{create_at});
  }
  $self->render(json => {error => 0, comments => $comment_list});
}

1;