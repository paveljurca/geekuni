#!/usr/bin/perl -Ilib

use Dancer2;
set template => 'template_toolkit';

use GuArt::Model;
use Data::Dump 'pp';
use feature 'say';

any [qw/get post/] => '/' => sub {
    my $img_ref = GuArt::Model::get_data();
    
    return template '/index' => {
        index_user  => params->{login_user},
        images      => $img_ref,
    };
};

get '/login' => sub {
    return template '/login';
};


dance;

