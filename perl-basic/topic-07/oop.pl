#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use DateTime;

my $dt = DateTime->now();
# say $dt->month_name();
# ~ 
say DateTime::month_name($dt); 
