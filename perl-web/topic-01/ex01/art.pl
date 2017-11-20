#!/usr/bin/perl

use Dancer2;

get '/' => sub {
    my($s, $m) = localtime;
    debug "$m:$s";
    return 'Hello World!';
};

dance;

