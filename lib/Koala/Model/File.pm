package Koala::Model::File;
use base qw/Koala::Model::Base/;
use File::Copy;
use Mojo::Upload;
use Imager;
use constant UPLOAD_DIR => './public/upload/';

__PACKAGE__->meta->setup(
  table => 'file',
  columns => [
    id          => { type => 'serial' , not_null => 1 },
    author_id   => { type => 'integer' },
    create_at   => { type => 'integer' },
    title       => { type => 'varchar', not_null => 1, length => 64 },
    path        => { type => 'varchar', not_null => 1, length => 64 },
    size        => { type => 'integer' },
    mime_type   => { type => 'varchar', length => 16 },
    extension   => { type => 'varchar', length => 8 },
  ],
  pk_columns => 'id',
  foreign_keys => [
    author => {
      class => 'Koala::Model::User',
      key_columns => { author_id => 'id'},
    },
  ],
);

# Method: _get_path
#   Protected method for getting real relative file path.
# Parameters:
#   $path - Str|Undef - path to dir/file
# Returns:
#   Str
sub _get_path {
  my $self = shift;
  my $path = shift || $self->path;
  my $const = UPLOAD_DIR;
  return $const . $path if $path !~ m{^$const};
  return $path;
}

# Method: get_url
#   Get relative url to this file.
# Parameters:
#   $path - Str|Undef - path to dir/file
# Returns:
#   Str
sub get_url {
  my $self = shift;
  my $path = shift || $self->path;
  my $const = UPLOAD_DIR;
  return $path if $path !~ m{^$const} && $path =~ m{^/};
  return '/'.$path if $path !~ m{^$const} && $path !~ m{^/};
  return substr($path, length($const) - 1);
}

# Method: init_by_mojo_asset
#   Create file entity from 'Mojo::Upload'.
# Parameters:
#   $file - Mojo::Upload - Mojo for initiation
# Returns:
#   Koala::Entity::File
sub init_by_mojo_asset {
  my $self = shift;
  my ($file) = @_;
  my $name = $file->filename;
  
  my ($ext) = ($name =~ /(\..+?)$/);
  $ext ||= '.000';
  my ($s, $i, $h, $d, $m, $y) = localtime;
  $y -= 100;
  $m = "0$m" if $m < 10;
  my $rand = int rand 123_456_789;
  
  mkdir UPLOAD_DIR.$y    unless -d UPLOAD_DIR.$y;
  mkdir UPLOAD_DIR."$y/$m" unless -d UPLOAD_DIR."$y/$m";
  $file->move_to(UPLOAD_DIR."$y/$m/$rand$ext");
  
  $self->extension($ext);
  $self->create_at(time);
  $self->path("$y/$m/$rand$ext");
  $self->size($file->size);
  
  return $self;
}

# Method: copy
#   Copy file.
# Parameters:
#   $dest - Str - path for new file
# Returns:
#   Koala::Entity::File
sub copy_file {
  my $self = shift;
  my ($source, $dest) = ($self->_get_path(shift), $self->_get_path(shift));
  die "Can't find file $source" unless -f $source;
  
  # mkdir -p $dest
  my @way = split /\//, $dest;
  pop @way; # file
  my $way;
  while (@way) {
    $way .= '/'.shift(@way);
    mkdir UPLOAD_DIR.$way unless -d UPLOAD_DIR.$way;
  }
  
  copy($source, $dest) or die "Copy failed: $!";
  
  my $new = __PACKAGE__->new();
  
  $new->$_($self->$_) for qw/author_id title size mime_type extension path/;
  $new->path($dest);
  $new->create_at(time);
  
  return $new;
}

# Method: generate_path
#   Generate path for lazy programmers.
# Parameters:
#   $dest - Str|Undef - origin path
# Returns:
#   Str - new path
sub generate_path {
  my $self = shift;
  my $dest = shift || $self->path;
  
  unless ($dest) {
    my ($s, $i, $h, $d, $m, $y) = localtime;
    $y -= 100;
    $m = "0$m" if $m < 10;
    my $rand = int rand 123_456_789;
    $dest = "$y/$m/$rand" . ($self->extension ? $self->extension : '');
    $self->path($dest);
  }
  
  my @path = split /\//, $dest;
  my $file = pop @path;
  my ($fn, $ext) = ($file =~ /(.*?)(\.[^\.]*)$/);
  $self->path(join('/', @path).'/'.$fn.'-'.(int rand 100_000).$ext);
  return $self->path;
}

# Method: crop
#   Crop an image.
# Parameters:
#   @params - Array|HashRef|Hash
#     Array: ($x, $y, $w, $h),
#     HashRef: {x=>$x, w=>$w, h=>$h, y=>$y}
#     Hash: x=>$x, w=>$w, h=>$h, y=>$y
#       Where
#         $x - Int - left offset
#         $y - Int - top offset
#         $w - Int - width of crop
#         $h - Int - height of crop
# Returns:
#   Koala::Entity::File
sub crop {
  my $self = shift;
  my @params = @_ == 8 ? {@_} : @_;
  my ($x, $y, $w, $h) = ref $params[0] ? @{$params[0]}{qw/x y w h/} : @params;
  
  my $image = new Imager;
     $image->read(file => $self->_get_path) or die $image->errstr;
     $image = $image->crop(left => $x, top => $y, width => $w, height => $h);
     $image->write(file => $self->_get_path) or die $image->errstr;
  
  return $self;
}

# Manager for File Model
package Koala::Model::File::Manager;
use base 'Rose::DB::Object::Manager';

sub object_class { 'Koala::Model::File' }

__PACKAGE__->make_manager_methods( 'files' );

1;

__END__

=pod

=head1 DATABASE STRUCTURE

=head2 MySQL

  CREATE TABLE IF NOT EXISTS `file` (
    `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
    `author_id` int(11) unsigned NOT NULL,
    `create_at` int(11) unsigned NOT NULL,
    `title` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
    `path` varchar(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
    `size` int(11) unsigned DEFAULT NULL,
    `mime_type` varchar(16) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `path` (`path`)
  ) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

=cut
