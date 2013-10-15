package Koala::Controller::File;
use Mojo::Base 'Mojolicious::Controller';
use Koala::Model::File;

sub upload {
  my $self = shift;
  return $self->not_found unless $self->user->is_active();
  my $file = Koala::Model::File->init_by_mojo_asset($self->param('upload'));
  $file->author_id($self->user->id);
  $file->save;
  my $text = qq{<script>window.parent.CKEDITOR.tools.callFunction(%s, '/upload/%s', '');</script>};
  return $self->render(text => sprintf $text, $self->param('CKEditorFuncNum'), $file->path);
}

1;