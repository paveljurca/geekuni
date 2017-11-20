#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use utf8;

use_ok('Airport::Data');
use_ok('Airport::Search');

#chomp(my $param = <>);

my @tests_name_match = (
    {
        string          => 'Air',
        is_word         => 0, #boolean
        num_expected    => 6, #num of results
    },
    {
        string          => 'Air',
        is_word         => 1,
        num_expected    => 0,
    },
    {
        string          => 'Airport',
        is_word         => 1,
        num_expected    => 6,
    },
    {
        string          => 'Ruzyně',
        #string          => $param,
        is_word         => 0,
        num_expected    => 1,
    },
    {
        string          => 'Ruzyně',
        #string          => $param,
        is_word         => 1,
        num_expected    => 1,
    },
);
my @tests_latlong_match = (
    {
        lat             =>  1,
        long            =>  1,
        max             =>  0.00001,
        num_expected    =>  0,
    },
    {
        # middle of the Atlantic
        lat             =>  40,
        long            =>  -35,
        max             =>  80, # ~ radius
        num_expected    =>  4, #Heathrow, JFK, de Gaull, Ruzyně
    },
    {
        # Heathrow exact coords
        lat             =>  51.4706001282,
        long            =>  -0.461941003799,
        max             =>  0.00001,
        num_expected    =>  1,
    },
);

# == testing ==
my $airports_ref = Airport::Data::parse_airports('t/data/airports1.csv');

# string SEARCH
for my $t (@tests_name_match) {
    my $m = Airport::Search::get_name_matching_airports(
        airports        => $airports_ref,
        matching_string => $t->{string},
        word            => $t->{is_word},
    );
    is(ref $m, 'ARRAY');
    is(ref $_, 'HASH') for (@{ $m });

    ok(@{ $m } == $t->{num_expected});
}

# [latitude, longitude] SEARCH
for my $t (@tests_latlong_match) {
    my $m = Airport::Search::get_latlong_matching_airports(
        airports        => $airports_ref,
        lat             => $t->{lat},
        long            => $t->{long},
        max             => $t->{max},
    );

    ok(@{ $m } == $t->{num_expected});
}

done_testing();
