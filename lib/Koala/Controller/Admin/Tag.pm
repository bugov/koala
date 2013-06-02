# Class: Koala::Controller::Admin::Tag
#   Admin panel for tags.
# Extends: Koala::Controller::Admin::Base

package Koala::Controller::Admin::Tag;
use Mojo::Base 'Koala::Controller::Admin::Base';
use Koala::Model::Tag;

has 'model_name' => 'tag';

1;

__END__

=pod

=head1 NAME

Koala::Controller::Admin::Tag - admin interface for tags.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013, Georgy Bazhukov <georgy.bazhukov@gmail.com> aka bugov <gosha@bugov.net>.

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=cut
