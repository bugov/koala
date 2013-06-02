# Class: Koala::Controller::Admin::Comment
#   Admin panel for comments.
# Extends: Koala::Controller::Admin::Base

package Koala::Controller::Admin::Comment;
use Mojo::Base 'Koala::Controller::Admin::Base';
use Koala::Model::Comment;

has 'model_name' => 'comment';

1;

__END__

=pod

=head1 Copyright and license

Copyright (C) 2013, Georgy Bazhukov <georgy.bazhukov@gmail.com> aka bugov <gosha@bugov.net>.
This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut