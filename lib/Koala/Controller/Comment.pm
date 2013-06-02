package Koala::Controller::Comment;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Comment;

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
  $comment_list->[$_] = $comment_list->[$_]->to_h for 0 .. $#$comment_list;
  $self->render(json => {error => 0, comments => $comment_list});
}

1;