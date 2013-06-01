# Class: Koala::Controller::Admin::Comment
#   Admin panel for comments.
# Extends: Mojolicious::Controller
package Koala::Controller::Admin::Comment;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::Comment;

# Var: size - list size
my $size = 20;

# Method: list
#   Show comment list splitted by pages.
# Parameters:
#   page - Int - page number.
sub list {
  my $self = shift;
  my $offset = $size * ($self->param('page') - 1);
  my $comment_list = Koala::Model::Comment::Manager->get_comments(sort_by => '-id', limit => $size, offset => $offset);
  my $comment_count = Koala::Model::Comment::Manager->get_comments_count;
  $self->render('page/admin/comments', comment_list => $comment_list, comment_count => $comment_count, limit => $size);
}

# Method: show
#   Show one comment (form for edit).
# Parameters:
#   id - Int - comment id
sub show {
  my $self = shift;
  my $id = $self->param('id');
  my $comment = eval {Koala::Model::Comment->new(id => $id)->load} or return $self->not_found;
  $self->render('comment/admin/show', comment => $comment);
}

1;

__END__

=pod

=head1 Copyright and license

Copyright (C) 2013, Georgy Bazhukov <georgy.bazhukov@gmail.com> aka bugov <gosha@bugov.net>.
This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut