#!/usr/bin/perl -Ilib

use Dancer2;
set template => 'template_toolkit';
set layout => 'main';

use GuArt::Model;
use Data::Dump 'pp';
use feature 'say';

my $img_ref = GuArt::Model::get_data();

any [qw/get post/] => '/' => sub {
    my $user = params->{login_user} || '';
#    my $message = $user . ($user eq 'Jill'
#        ? ' darling, we simply must have it all!' : '');
    my $message = $user.' darling, we simply must have it all!';

    return template '/index' => {
        index_user  => $user,
        message     => $message,
        artworks    => $img_ref,
    };
};

get '/login' => sub {
    return template '/login';
};

get '/closeup' => sub {
    my $img_id = params->{image_id};

    return template '/image' => {
        image_data => $img_ref->{$img_id},
    };
};

dance;

