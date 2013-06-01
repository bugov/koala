package Koala::Controller::Admin::Page;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Page;
use Koala::Model::Comment;
use Koala::Entity::File;

my $size = 20;

# Method: list
#   List of pages. $size is a SQL limit.
sub list {
  my $self = shift;
  my $page = int $self->param('page');
  my $page_list = Koala::Model::Page::Manager->get_pages(sort_by => 'id', limit => $size, offset => $size * ($page-1));
  my $page_count = Koala::Model::Page::Manager->get_pages_count;
  $self->render('page/admin/list', page_list => $page_list, page_count => $page_count, limit => $size);
}

# Method: show
#   Show one page for editing.
sub show {
  my $self = shift;
  my $page = Koala::Model::Page->new(id => int $self->param('id'))->load;
  $self->render('page/admin/form', page => $page);
}

# Method: edit
#   Edit one page. Don't show form, just edit.
sub edit {
  my $self = shift;
  my $page = Koala::Model::Page->new(id => int $self->param('id'))->load;
  
  $page->$_($self->param($_)) for qw/url title legend status
    keywords description text author_id approver_id owner_id/;
  $page->create_at($self->dt($self->param('create_at')));
  $page->modify_at($self->dt($self->param('modify_at')));
  
  if ($self->param('picture')->size) { # Load picture if exists
    my $file = Koala::Entity::File->new->init($self->param('picture'));
    $file->author_id($self->user->id);
    $file->save;
    $page->picture_id($file->id); 
  }
  
  $page->save;
  
  $self->flash({message => 'Page edited', type => 'success'})
    ->redirect_to('admin_page_show', id => $page->id);
}

# Method: create
#   Create one page. Just create.
sub create {
  my $self = shift;
  my $page = Koala::Model::Page->new();
  $page->$_($self->param($_)) for qw/url title legend status
    keywords description text author_id approver_id owner_id/;
  $page->create_at($self->dt($self->param('create_at')));
  $page->modify_at($self->dt($self->param('modify_at')));
  $page->save;
  $self->flash({message => 'Page created', type => 'success'})
    ->redirect_to('admin_page_show', id => $page->id);
}

1;

__END__

=pod

=head1 NAME

Koala::Controller::Admin::Page - admin interface for pages.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013, Georgy Bazhukov <georgy.bazhukov@gmail.com> aka bugov <gosha@bugov.net>.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
