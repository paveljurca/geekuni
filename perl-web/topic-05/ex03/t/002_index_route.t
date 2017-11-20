#!/usr/bin/perl

use Test::More tests => 2;
use strict;
use warnings;

##############################################################
# https://gist.github.com/andrewsolomon/8c05fa06f6df3d6938d9 #
##############################################################

# perl -MPlack -le 'print $Plack::VERSION'
# 0.9985
# this Plack VERSION lacks 'create'
use Plack::Test;
use HTTP::Request::Common;

use GuArt::Controller;

# my $app = GuArt::Controller->psgi_app;
# my $test = Plack::Test->create($app);

my $app = 'GuArt::Controller';


my $res;

$res = $test->request( GET "/");
is $res->code, 302, 'response status is 302 for / without logging in';

$res = $test->request( POST "/",[
        login_user => 'Andrew',
]);
is $res->code, 200, 'successful 200 response on login';

