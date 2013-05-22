package Koala::Controller::Page;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Page;
use Koala::Model::Comment;

my $size = 10;

sub show {
  my $self = shift;
  my $page = eval{Koala::Model::Page->new(url => $self->param('url'))->load} or return $self->not_found;
  my $comment_list = Koala::Model::Comment::Manager->get_comments(where => [page_id => $page->id], sort_by => '-id', limit => $size);
  my $comment_count = Koala::Model::Comment::Manager->get_comments_count(where => [page_id => $page->id]);
  $self->render(page => $page, comment_list => $comment_list, comment_count => $comment_count);
}

1;
