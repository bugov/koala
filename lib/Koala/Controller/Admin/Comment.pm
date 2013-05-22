package Koala::Controller::Admin::Comment;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Comment;

my $size = 20;

sub list {
  my $self = shift;
  my $offset = $size * ($self->param('page') - 1);
  my $comment_list = Koala::Model::Comment::Manager->get_comments(sort_by => '-id', limit => $size, offset => $offset);
  my $comment_count = Koala::Model::Comment::Manager->get_comments_count;
  $self->render('page/admin/comments', comment_list => $comment_list, comment_count => $comment_count, limit => $size);
}

sub show {
  my $self = shift;
  my $id = $self->param('id');
  my $comment = eval {Koala::Model::Comment->new(id => $id)->load} or return $self->not_found;
  $self->render('comment/admin/show', comment => $comment);
}

1;