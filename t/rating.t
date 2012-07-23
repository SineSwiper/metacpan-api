#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 7;
use Test::Fatal;
use t::lib::Functions;

my $mcpan = mcpan();

isa_ok( $mcpan, 'MetaCPAN::API' );
can_ok( $mcpan, 'rating'        );
my $errmsg = qr/^Either provide 'id' or 'search'/;

# missing input
like(
    exception { $mcpan->rating },
    $errmsg,
    'Missing any information',
);

# incorrect input
like(
    exception { $mcpan->rating( ding => 'dong' ) },
    $errmsg,
    'Incorrect input',
);

my $result = $mcpan->rating(
    search => {
        filter => "distribution:Moose",
        fields => [ "date", "rating" ],
    },
);
ok( $result, 'Got result' );
my $rating_id = $result->{hits}{hits}[0]{_id};

$result = $mcpan->rating($rating_id);
ok( $result, 'Got result' );

$result = $mcpan->rating( id => $rating_id );
ok( $result, 'Got result' );
