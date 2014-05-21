package Test::Mech;
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

sub delete_ {
  my ($self, $uri, $options) = @_;
  $self->request('DELETE', $uri, $options);
}

1
__END__
