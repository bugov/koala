package Koala::Controller::File;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Entity::File;

sub upload {
  my $self = shift;
  my $file = Koala::Entity::File->new->init($self->param('upload'));
  $file->author_id($self->user->id);
  $file->save;
  my $text = qq{<script>window.parent.CKEDITOR.tools.callFunction(%s, '/upload/%s', '');</script>};
  return $self->render(text => sprintf $text, $self->param('CKEditorFuncNum'), $file->path);
}

1;