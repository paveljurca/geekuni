#!/usr/bin/perl -Ilib

use Dancer2;
use Dancer2::Plugin::Logout;

set
    template    => 'template_toolkit',
    layout      => 'main',
    session     => 'Simple',
;

use GuArt::Model;
#use Data::Dump 'pp';
#use feature 'say';

hook before => sub {
    #debug 'req => '.request->path;

    #login first!
    unless (session('user')
        || params->{login_user}
        || request->path =~ m{^/(?:login|favicon.ico)}) {

        return redirect '/login'.request->path;
    }

    if (session('refresh_prices')) {
        GuArt::Model::update_prices(session('artworks'));
        session refresh_prices => 0;
    }
};

any [qw/get post/] => '/' => sub {
    my $u = params->{login_user};
    if ($u && !session($u)) {
        session user => $u;
        var message
            => 'Hello '.session('user').'. A gin and tonic for you?';
    }

    if (session('on_my_way_to')) {
        my $goto = session->delete('on_my_way_to');
       
        #return forward $goto, { }, { method => 'GET' };
        return redirect $goto; 
    }

    return template '/index' => {
        index_user      => session('user'),
        message         => vars->{message} || generate_message(),
        artworks        => session('artworks'),
        cash_reserve    => session('cash_reserve'),
    };
};

get qr{/login(.*)} => sub {
    #get the wildcard match
    my ($suffix_url) = splat;
    
    #you're already logged in
    return redirect '/' if session('user');

    session artworks
        => GuArt::Model::get_data;
    session cash_reserve 
        => 1000;
    session refresh_prices
        => 1;

    session on_my_way_to
        => $suffix_url if $suffix_url ne '/';

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

get '/buy/:idx' => sub {
    session('artworks')->{params->{idx}}->{own} = 1;

    return redirect '/';
};

get '/sell/:idx' => sub {
    session('artworks')->{params->{idx}}->{own} = 0;

    return redirect '/';
};

sub generate_message {
    return session('user').' darling, we simply must have it all!';;
}

dance;

