#!/usr/bin/perl

use Dancer2;

get '/' => sub {
    my($s, $m) = localtime;
    debug "$m:$s";
    return 'Hello World!';
#    return send_file('/home/student/perl-basic.tar', system_path=>1);
};

dance;

