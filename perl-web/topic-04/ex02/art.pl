#!/usr/bin/perl -Ilib

use Dancer2;
use Dancer2::Plugin::Logout;

set template    => 'template_toolkit';
set layout      => 'main';
set session     => 'Simple';

use GuArt::Model;
#use Data::Dump 'pp';
#use feature 'say';

hook before => sub {
    #login first!
    unless (session('user')
        || params->{login_user}
        || request->path eq '/login') {

        return redirect '/login';
    }

    if (session('refresh_prices')) {
        GuArt::Model::update_prices(session('artworks'));
        session refresh_prices => 0;
    }
};

any [qw/get post/] => '/' => sub {
    if (params->{login_user} and !session('user')) {
        session 'user' => params->{login_user};
        var message
            => 'Hello '.session('user').'. A gin and tonic for you?';
    }

    return template '/index' => {
        index_user      => session('user'),
        message         => vars->{message} || generate_message(),
        artworks        => session('artworks'),
        cash_reserve    => session('cash_reserve'),
    };
};

get '/login' => sub {
    return redirect '/' if session('user');

    session artworks
        => GuArt::Model::get_data;
    session cash_reserve 
        => 1000;
    session refresh_prices
        => 1;

    return template '/login';
};

get '/logout' => sub { logout };

get '/closeup/:image_id' => sub {
    my $img_id = params->{image_id};

    return template '/image' => {
        index_user  => session('user'),
        message     => generate_message(),
        image_data => session('artworks')->{$img_id},
    };
};

sub generate_message {
    return session('user').' darling, we simply must have it all!';;
}

dance;

