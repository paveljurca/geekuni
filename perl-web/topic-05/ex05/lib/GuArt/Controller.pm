package GuArt::Controller;

use Dancer2;
use Dancer2::Plugin::Logout;

use GuArt::Model;
#use Data::Dump 'pp';
#use feature 'say';

hook before => sub {
    debug 'request path: '.request->path;

    #login first!
    unless (session('user')
        || params->{login_user}
        || request->path =~ m{^/(?:login|favicon\.ico|retrieve-data|.*\.css$)}) {

        return redirect '/login'.request->path;
    }

    if (session('refresh_prices')) {
        GuArt::Model::update_prices(session('data'));
        session refresh_prices => 0;
    }
};

any [qw/get post/] => '/' => sub {
    my $u = params->{login_user};
    if ($u && !session($u)) {
        session user => $u;
    }

    if (session('on_my_way_to')) {
        my $goto = session->delete('on_my_way_to');
       
        #return forward $goto, { }, { method => 'GET' };
        return redirect $goto; 
    }

    return template '/index' => {
        index_user      => session('user'),
        message         => generate_message(),
        artworks        => session('data'),
        cash_reserve    => session('cash_reserve'),
    };
};

get qr{/login(.*)} => sub {
    #get the wildcard match
    my ($suffix_url) = splat;
    
    #you're already logged in
    return redirect '/' if session('user');

    session data
        => GuArt::Model::get_data;
    session cash_reserve 
        => 1000;
    session refresh_prices
        => 1;
    session on_my_way_to
        => $suffix_url if $suffix_url ne '/';

    return template '/login';
};

get '/logout' => sub {
    warning 'User '.session('user').' is logging out';
    logout;
};

get '/closeup/:image_id' => sub {
    my $img_id = params->{image_id};

    return template '/image' => {
        index_user  => session('user'),
        message     => generate_message(),
        image_data => session('data')->{$img_id},
    };
};

sub retrieve_data {
  my $retval = to_json({
    artworks      => session('data'),
    cash_reserve  => session('cash_reserve'),
    index_user    => session('user'),
    message       => generate_message(),
  }, {pretty => 1 });

  return $retval;
}

get '/retrieve-data' => sub {
  return retrieve_data();
};

get '/toggle-ownership/:idx' => sub {
  my $selling = session('data')->{param('idx')}->{own};
  session('data')->{param('idx')}->{own} = !  session('data')->{param('idx')}->{own};

  my $delta = $selling ? 1 : -1;
  session 'cash_reserve' => session('cash_reserve') +
    $delta * session('data')->{param('idx')}->{price};
  session 'transactions' => session('transactions') + 1;
  GuArt::Model::update_prices(session('data'));

  return retrieve_data();
};

sub generate_message {
    return session('transactions')
        ? session('user').' darling, we simply must have it all!'
        : 'Hello '.session('user').'. A gin and tonic for you?';
}

1;
