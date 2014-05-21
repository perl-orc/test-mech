package Test::Mech;

# ABSTRACT: Simple PSGI request wrapper tester

use Moo;

has app => (
  is => 'ro',
  isa => sub {die("app must be a CodeRef!") unless ref(shift) eq 'CODE';},
  required => 1,
);

sub request {
  my ($self, $method, $uri, $options) = @_;
  $options ||= {};
  $self->app->({
    REQUEST_METHOD => $method,
    SCRIPT_NAME => $uri,
    PATH_INFO => "",
    REQUEST_URI => $uri,
    QUERY_STRING => ($options->{'query'}||""),
    SERVER_NAME => ($options->{'server-name'}||"localhost"),
    SERVER_PORT => ($options->{'server-port'}||80),
    SERVER_PROTOCOL => ($options->{'server-protocol'}||'http'),
    HTTP_HOST => ($options->{'server-name'}||"localhost"),
  });
}

sub get {
  my ($self, $uri, $options) = @_;
  $self->request('GET', $uri, $options);
}

sub post {
  my ($self, $uri, $options) = @_;
  $self->request('POST', $uri, $options);
}

sub put {
  my ($self, $uri, $options) = @_;
  $self->request('PUT', $uri, $options);
}

sub del {
  my ($self, $uri, $options) = @_;
  $self->request('DELETE', $uri, $options);
}

1
__END__

=head1 SYNOPSIS

I think the (short but comprehensive) test file says it best:

    use Test::Most;
    use Test::Mech;
    use Carp qw(carp cluck confess croak);

	sub app {
	  my %env = %{(shift)};
	  my $method = $env{REQUEST_METHOD};
	  my $uri = $env{REQUEST_URI};
	  return [$method, $uri];
	}

	my $mech = Test::Mech->new(app => \&app);
	eq_or_diff($mech->get('/foo'),['GET', '/foo']);
	eq_or_diff($mech->post('/bar/foo'),['POST', '/bar/foo']);
	eq_or_diff($mech->put('/baz/'),['PUT', '/baz/']);
	eq_or_diff($mech->del('/baz/foo/'),['DELETE', '/baz/foo/']);

	done_testing;

=head1 METHODS

Methods expect (unlisted here) $self, so are generally expected to be invoked with ->.

=head2 new(%kwargs) => Test::Mech

Keyword args:
  C<app>: The PSGI subref we will be testing

Given a PSGI application, constructs a Test::Mech and returns it

=head2 get($uri: Str, $config: Maybe[HashRef]) => Any

GETs a uri to the app, returning output. C<$config> is an optional hashref that alters parameters in the generated PSGI request. The following is a mapping of keys we search to keys in the PSGI Request hash that will be generated:

    config key      psgi request key  notes
    ----------      ----------------  -----
    query           QUERY_STRING
    server-name     SERVER_NAME
    server-port     SERVER_PORT
    server-protocol SERVER_PROTOCOL
    http_host       HTTP_HOST         Falls back to server-name

=head2 post($uri: Str, $config: Maybe[HashRef]) => Any

POSTs a uri to the app, returning output. C<$config> treated as per C<get>

=head2 put($uri: Str, $config: Maybe[HashRef]) => Any

PUTs a uri to the app, returning output. C<$config> treated as per C<get>

=head2 del($uri: Str, $config: Maybe[HashRef]) => Any

DELETEs a uri to the app, returning output. C<$config> treated as per C<get>
