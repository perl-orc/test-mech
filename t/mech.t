use Test::Most;

use Test::Mech;

use Carp qw(carp cluck confess croak);

sub app {
  my %env = %{(shift)};
  my $method = $env{REQUEST_METHOD};
  my $uri = $env{REQUEST_URI};
  return [$method, $uri];
}

warn "app: ".ref(\&app);
my $mech = Test::Mech->new(app => \&app);
eq_or_diff($mech->get('/foo'),['GET', '/foo']);
eq_or_diff($mech->post('/bar/foo'),['POST', '/bar/foo']);
eq_or_diff($mech->put('/baz/'),['PUT', '/baz/']);
eq_or_diff($mech->delete_('/baz/foo/'),['DELETE', '/baz/foo/']);

done_testing;
