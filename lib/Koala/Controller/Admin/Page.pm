package Koala::Controller::Admin::Page;
use Mojo::Base 'Koala::Controller::Admin::Base';
use Koala::Model::Page;
use Koala::Model::Comment;
use Koala::Model::Tag;
use Koala::Entity::File;

has 'model_name' => 'page';

# Method: list
#   List of pages. $size is a SQL limit.
sub list {
  my $self = shift;
  my $page = int $self->param('page');
  my $page_list = eval { Koala::Model::Page::Manager
    ->get_pages(sort_by => '-id', limit => $size, offset => $size * ($page-1)) }
      or return $self->not_found;
  my $page_count = Koala::Model::Page::Manager->get_pages_count;
  $self->render('page/admin/list', page_list => $page_list, page_count => $page_count, limit => $size);
}

# Method: _dehydrate
#   Redefine if you wanna custom work with input.
sub _dehydrate {
  my ($self, $page) = @_;
  my ($model) = $self->_get_model();
  $page->$_($self->param($_)) for qw/url title legend status
    keywords description text author_id approver_id owner_id category_id/;
  $page->create_at($self->dt($self->param('create_at')));
  $page->modify_at($self->dt($self->param('modify_at')));
    
  if ($self->param('picture')->size) { # Load picture if exists
    my $file = Koala::Entity::File->new->init($self->param('picture'));
    $file->author_id($self->user->id);
    $file->save;
    $page->picture_id($file->id); 
  }
  
  $page->setTags(title => split /, /, $self->param('tags'));
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
