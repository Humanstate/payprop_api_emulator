#!perl

use strict;
use warnings;

BEGIN {
	# JSON::Validator caches API specs, removed them first
	use JSON::Validator;
	foreach my $path ( @{ JSON::Validator->new->cache_paths } ) {
		foreach my $file ( grep { -f } glob( "$path/*" ) ) {
			print "Removing cached file: $file\n";
			unlink( $file ) || die "Failed to unlilnk $file: $!";
		}
	};
};

use Mojolicious::Lite;
use Mojo::UserAgent;
use JSON::Schema::ToJSON;

# we need these for emulation
foreach ( qw/
	PP_API_CLIENT_IDENTIFIER
	PP_API_CLIENT_REDIRECT_URI
	PP_API_JWT_SECRET
/ ) {
	$ENV{$_} // die "$_ is required";
}

# setup OAuth2 handling
plugin 'OAuth2::Server' => {
	jwt_secret => $ENV{PP_API_JWT_SECRET},
	clients    => {
		$ENV{PP_API_CLIENT_IDENTIFIER} => {
			redirect_uri => $ENV{PP_API_CLIENT_REDIRECT_URI},
			scopes       => {},
		},
	},
};
 
my $api = app->routes->under( '/api/v1.0' )->to( cb => sub {
	my ( $c ) = @_;

	# CORS headers, update the Allow-Methods as necessary
	my $header = 'Access-Control-Allow';
	$c->res->headers->append( "$header-Origin" => '*' );
	$c->res->headers->append( "$header-Methods" => 'GET, OPTIONS' );
	$c->res->headers->append(
		"$header-Headers" => 'Content-Type, Authorization'
	);

	if (
		# all none OPTIONS calls to API require a valid access token
		$c->req->method ne 'OPTIONS'
		&& ! $c->oauth
	) {
		$c->render( status => 401, json => { error => 'Denied' } );
		return 0;
	}

	return 1;
} );

# OPTIONS catch-all route
$api->options( '/*whatever' => sub {
	shift->respond_to( any => { json => '', status => 204 } );
});
 
# setup API routes from swagger config
plugin OpenAPI => {
	route => $api,
	url   => "https://za.payprop.com/api/docs/api_spec.yaml",
};

app->helper( 'openapi.not_implemented' => sub {
	my ( $c ) = @_;

	my $spec = $c->openapi->spec;
	if (my ($response) = grep { /^2/ } sort keys(%{$spec->{'responses'}})) {
		my $schema = $spec->{'responses'}{$response}{schema};
		return {
			status => $response,
			json   => JSON::Schema::ToJSON->new(
				example_key => 'x-example',
			)->json_schema_to_json( schema => $schema ),
		};
	}

	return {json => {errors => [{message => 'Not implemented.', path => '/'}]}, status => 501};
});


app->start;
