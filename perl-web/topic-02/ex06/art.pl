#!/usr/bin/perl -Ilib

use Dancer2;
set template => 'template_toolkit';
set layout => 'main';

use GuArt::Model;
use Data::Dump 'pp';
use feature 'say';

my $img_ref = GuArt::Model::get_data();

any [qw/get post/] => '/' => sub {    
    return template '/index' => {
        index_user  => params->{login_user},
        images      => $img_ref,
    };
};

get '/login' => sub {
    return template '/login';
};

get '/closeup' => sub {
    my $img_id = params->{image_id};

    return template '/image' => {
        artwork => $img_ref->{$img_id},
    };
};

dance;

