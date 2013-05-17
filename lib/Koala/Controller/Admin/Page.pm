package Koala::Controller::Admin::Page;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Page;
use Koala::Model::Comment;

my $size = 20;

sub approve {
  
}

sub comments {
  my $self = shift;
  my $offset = $size * ($self->param('page') - 1);
  my $comment_list = Koala::Model::Comment::Manager->get_comments(sort_by => '-id', limit => $size, offset => $offset);
  my $comment_count = Koala::Model::Comment::Manager->get_comments_count;
  $self->render('page/admin/comments', comment_list => $comment_list, comment_count => $comment_count, limit => $size);
}

sub list {
  my $self = shift;
  my $page = int $self->param('page');
  my $page_list = Koala::Model::Page::Manager->get_pages(sort_by => 'id', limit => $size, offset => $size * ($page-1));
  my $page_count = Koala::Model::Page::Manager->get_pages_count;
  $self->render('page/admin/list', page_list => $page_list, page_count => $page_count, limit => $size);
}

sub show {
  my $self = shift;
  my $page = Koala::Model::Page->new(id => int $self->param('id'))->load();
  $self->render('page/admin/form', page => $page);
}

sub edit {
  my $self = shift;
  my $page = Koala::Model::Page->new(id => int $self->param('id'))->load();
  $page->$_($self->param($_)) for qw/url title legend status
    keywords description text author_id approver_id owner_id/;
  $page->create_at($self->dt($self->param('create_at')));
  $page->modify_at($self->dt($self->param('modify_at')));
  $page->save;
  $self->redirect_to('admin_page_show', id => $page->id);
}

sub create {
  my $self = shift;
  my $page = Koala::Model::Page->new();
  $page->$_($self->param($_)) for qw/url title legend status
    keywords description text author_id approver_id owner_id/;
  $page->create_at($self->dt($self->param('create_at')));
  $page->modify_at($self->dt($self->param('modify_at')));
  $page->save;
  $self->redirect_to('admin_page_show', id => $page->id);
}

1;