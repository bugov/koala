package Koala::Controller::Admin::User;
use Mojo::Base 'Koala::Controller::Admin::Base';
use Koala::Model::User;

has 'model_name' => 'user';

# Method: list
#   Show user list.
sub list {
  my $self = shift;
  my $page = int $self->param('page');
  my $user_list = Koala::Model::User::Manager->get_users(
    sort_by => 'id', limit => $self->size,
    offset => $self->size * ($page-1)
  );
  my $user_count = Koala::Model::User::Manager->get_users_count();
  $self->render('user/admin/list', user_list => $user_list, user_count => $user_count, limit => $self->size);
}

# Method: _dehydrate
#   Redefine if you wanna custom work with input.
sub _dehydrate {
  my ($self, $user) = @_;
  my ($model) = $self->_get_model();
  $user->$_($self->param($_)) for qw/username email info role/;
  $user->create_at( $self->dt($self->param('create_at')) );
  $user->new_password($self->param('password')) if $self->param('password');
}

1;

__END__

=pod

=head1 NAME

Koala::Controller::Admin::User - admin interface for users.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013, Georgy Bazhukov <georgy.bazhukov@gmail.com> aka bugov <gosha@bugov.net>.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut