package Koala::Controller::Admin::Page;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Page;

sub approve {
  
}

sub list {
  my $self = shift;
  my $page_list =  Koala::Model::Page::Manager->get_pages(
    sort_by => 'id', limit => 50,
    offset => 50 * int $self->param('page')
  );
  my $page_count = Koala::Model::Page::Manager->get_pages_count();
  $self->render('page/admin/list', page_list => $page_list, page_count => $page_count);
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
  $page->save();
  $self->redirect_to('admin_page_show', id => $page->id);
}

sub create {
  my $self = shift;
  my $page = Koala::Model::Page->new();
  $page->$_($self->param($_)) for qw/url title legend status
    keywords description text author_id approver_id owner_id/;
  $page->create_at($self->dt($self->param('create_at')));
  $page->modify_at($self->dt($self->param('modify_at')));
  $page->save();
  $self->redirect_to('admin_page_show', id => $page->id);
}

1;