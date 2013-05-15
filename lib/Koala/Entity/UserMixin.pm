package Koala::Entity::UserMixin;
use Mojo::Base -base;
use Digest::MD5 "md5_hex";


# Method: get_session_data
#   Get data, which we can use in session.
# Return: HashRef

sub get_session_data {
  my $self = shift;
  return {
    id => $self->id,
    username => $self->username,
    email => $self->email,
    role => $self->role,
  };
}


# Method: set_role
#   Set role by name
# Parameter: $role - Str

sub set_role {
  my ($self, $role) = @_;
  die 'Invalid role' unless exists $self->roles->{$role};
  $self->role = $self->roles->{$role};
}


# Method: new_password
#   Change user's password
# Parameter: $password - Str

sub new_password {
  my ($self, $password) = @_;
  my $salt = substr md5_hex(rand), 0, 7;
  my $hex = md5_hex($salt.$password);
  $self->password($salt.'$'.$hex);
}


# Method: test_password
#   Does some string eq password
# Parameter: $password - Str
# Return: 1|0 - Boolean

sub test_password {
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
  inactive=> 40,
  user    => 50,
  staff   => 80,
  admin   => 99
}};


sub is_guest {
  my $self = shift;
  return 1 unless defined $self->role;
  return 1 if $self->role < $self->roles->{'inactive'};
  return 0;
}

sub is_registred {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->role > $self->roles->{'guest'};
  return 0;
}

sub is_active {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->role >= $self->roles->{'user'};
  return 0;
}

sub is_user {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->role >= $self->roles->{'user'};
  return 0;
}

sub is_staff {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->role >= $self->roles->{'staff'};
  return 0;
}

sub is_admin {
  my $self = shift;
  return 0 unless defined $self->role;
  return 1 if $self->role >= $self->roles->{'admin'};
  return 0;
}

1;