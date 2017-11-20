#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use_ok('Airport::Data');
# Essentially the same as:
#     use Airport::Data;
# but outputting:
#     ok 1 - use Airport::Data;
# to indicate that the module loaded successfully.

use Data::Types qw/:float/;

#array
my $airports_ref = Airport::Data::parse_airports('t/data/airports1.csv');

#ok(ref $airports_ref eq 'ARRAY');
#ok(@{ $airports_ref } == 6, 'correct number');

is(ref $airports_ref, 'ARRAY', 'parse_airports returns the correct type');
is(scalar @{ $airports_ref }, 6, 'correct number');

is(ref $_, 'HASH') for @{ $airports_ref };

for my $h (@{ $airports_ref }) {
    ok(exists $h->{$_} and $h->{$_} =~ /\S+/)
        for (qw/id name latitude_deg longitude_deg iata_code/);

    ok(is_float($h->{$_}), 'floating point')
        for (qw/latitude_deg longitude_deg/);
}

ok(1, 'non zero is good ');
#ok(0, 'zero is bad');

done_testing();
# Note, without done_testing at the end
# it will suspect the test script died part way through.
