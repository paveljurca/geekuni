#!/usr/bin/perl -Ilib

use Dancer2;
use GuArt::Model;
use Data::Dump 'pp';
use feature 'say';

any [qw/get post/] => '/' => sub {
    my $img_ref = GuArt::Model::get_data();
    my @files = map $_->{filename},
        values %{ $img_ref };
    
    return template '/index' => {
        index_user  => params->{login_user},
        images      => \@files,
    };
};

get '/login' => sub {
    return template '/login';
};


dance;

