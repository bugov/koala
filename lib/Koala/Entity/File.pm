package Koala::Entity::File;
use Mojo::Base -base;
use Mojo::Upload;
use Koala::Model::File;

has 'id';
has 'author_id';
has 'create_at';
has 'title';
has 'path';
has 'size';
has 'mime_type';

sub init {
  my $self = shift;
  my ($file) = @_;
  my $name = $file->filename;
  
  my ($ext) = ($name =~ /(\..+?)$/);
  $ext ||= '.000';
  my ($s, $i, $h, $d, $m, $y) = localtime;
  $y -= 100;
  $m = "0$m" if $m < 10;
  my $rand = int rand 123_456_789;
  
  mkdir "./public/upload/$y"    unless -d "./public/upload/$y";
  mkdir "./public/upload/$y/$m" unless -d "./public/upload/$y/$m";
  $file->move_to("./public/upload/$y/$m/$rand$ext");
  
  $self->create_at(time);
  $self->path("$y/$m/$rand$ext");
  $self->size($file->size);
  
  return $self;
}

sub save {
  my $self = shift;
  my $file = do {
    $self->id ?
      Koala::Model::File->new(id => $self->id)->load :
      Koala::Model::File->new
  };
  $file->$_($self->$_) for $file->meta->column_names;
  $file->save;
  $self->id($file->id);
  
  return $self;
}

1;