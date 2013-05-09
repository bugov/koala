package Koala::Entity::UserMixin;
use Mojo::Base -base;
use Digest::MD5 "md5_hex";


# Method: getSessionData
#   Get data, which we can use in session.
# Return: HashRef

sub getSessionData {
  my $self = shift;
  return {
    id => $self->id,
    username => $self->username,
    email => $self->email,
    role => $self->role,
  };
}


# Method: newPassword
#   Change user's password
# Parameter: $password - Str

sub newPassword {
  my ($self, $password) = @_;
  my $salt = substr md5_hex(rand), 0, 7;
  my $hex = md5_hex($salt.$password);
  $self->password($salt.'$'.$hex);
}


# Method: testPassword
#   Does some string eq password
# Parameter: $password - Str
# Return: 1|0 - Boolean

sub testPassword {
  my ($self, $password) = @_;
  my ($salt, $hex) = split /\$/, $self->password;
  return 1 if md5_hex($salt.$password) eq $hex;
  return 0;
}


# Work with roles.
# Posible roles:
#   guest
#   inactive
#   user
#   staff
#   admin

has 'roles' => sub {{
  guest   => 0,
  inactive=> 10,
  user    => 20,
  staff   => 30,
  admin   => 99
}};


sub isGuest {
  my $self = shift;
  return 1 unless defined $self->role;
  return 1 if $self->roles->{ $self->role } < $self->roles->{'inactive'};
  return 0;
}

sub isRegistred {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->roles->{ $self->role } > $self->roles->{'guest'};
  return 0;
}

sub isActive {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->roles->{ $self->role } >= $self->roles->{'user'};
  return 0;
}

sub isUser {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->roles->{ $self->role } >= $self->roles->{'user'};
  return 0;
}

sub isStaff {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->roles->{ $self->role } >= $self->roles->{'staff'};
  return 0;
}

sub isAdmin {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->roles->{ $self->role } >= $self->roles->{'admin'};
  return 0;
}

1;