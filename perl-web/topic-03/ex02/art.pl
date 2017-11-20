#!/usr/bin/perl -Ilib

use Dancer2;
set template    => 'template_toolkit';
set layout      => 'main';
set session     => 'Simple';

use GuArt::Model;
use Data::Dump 'pp';
use feature 'say';

my $img_ref = GuArt::Model::get_data();

any [qw/get post/] => '/' => sub {
    my $user = params->{login_user};
    if ($user) {
        session 'user' => $user;
    }
    unless (session('user')) {
        #login first!
        return forward '/login';
    }

    return template '/index' => {
        index_user  => session('user'),
        message     => generate_message(),
        artworks    => $img_ref,
    };
};

get '/login' => sub {
    return redirect '/' if session('user');

    return template '/login';
};

get '/closeup' => sub {
    unless (session('user')) {
        #login first!
        return forward '/login';
    }
    
    my $img_id = params->{image_id};

    return template '/image' => {
        index_user  => session('user'),
        message     => generate_message(),
        image_data => $img_ref->{$img_id},
    };
};

sub generate_message {
    return session('user').' darling, we simply must have it all!';;
}

dance;

