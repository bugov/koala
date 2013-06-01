# Class: Koala::Controller::Admin::Category
#   Admin panel for categories.
# Extends: Mojolicious::Controller

package Koala::Controller::Admin::Category;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Category;

# Var: size - list size
my $size = 20;

# Method: list
#   Show category list splitted by pages.
# Parameters:
#   page - Int - page number.
sub list {
  my $self = shift;
  my $offset = $size * ($self->param('page') - 1);
  my $list = Koala::Model::Category::Manager->get_categories(sort_by => '-id', limit => $size, offset => $offset);
  my $count = Koala::Model::Category::Manager->get_categories_count;
  $self->render('category/admin/list', list => $list, count => $count, limit => $size);
}

# Method: show
#   Show one category for editing.
# Parameters:
#   id - Int - category id
sub show {
  my $self = shift;
  my $item = eval {Koala::Model::Category->new(id => int $self->param('id'))->load} or return $self->not_found;
  $self->render('category/admin/form', item => $item);
}

# Method: create
#   Create category.
# Parameters:
#   url - Str
#   title - Str
#   legend - Str - short description
sub create {
  my $self = shift;
  my $cat = Koala::Model::Category->new();
  $cat->$_($self->param($_)) for qw/url title legend/;
  $cat->save;
  $self->flash({message => 'Category created', type => 'success'})
    ->redirect_to('admin_category_show', id => $cat->id);
}

# Method: edit
#   Edit category.
# Parameters:
#   id - Int
#   url - Str
#   title - Str
#   legend - Str - short description
sub edit {
  my $self = shift;
  my $cat = Koala::Model::Category->new(id => int $self->param('id'))->load;
  $cat->$_($self->param($_)) for qw/url title legend/;
  $cat->save;
  $self->flash({message => 'Category edited', type => 'success'})
    ->redirect_to('admin_category_show', id => $cat->id);
}

1;

__END__

=pod

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013, Georgy Bazhukov <georgy.bazhukov@gmail.com> aka bugov <gosha@bugov.net>.
This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
