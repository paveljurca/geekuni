#!/usr/bin/perl -Ilib

use Dancer2;
use GuArt::Model;

get '/' => sub {
    my $user;
    if (params->{login_user}) {
        $user = "<h1>Hello " . params->{login_user} . "</h1>";
    }
    else {
        $user = 'bad you motherfucker';
    }
    
    my $img_ref = GuArt::Model::get_data();
    my $img_list = join "\n<br/>\n",
            map qq(<img src="images/$img_ref->{$_}->{filename}" />), keys %{ $img_ref };

    return <<HTML;
<!doctype html>
<html lang="en">
  <head>
  </head>
  <body>
    $user;
    $img_list 
  </body>
</html>
HTML
};

get '/login' => sub {
    return <<HTML;
<!doctype html>
<html>
  <head>
  </head>
  <body>
    <form action="/" method="get">
      Your name: <input type="text" name="login_user" />
      <br />
      <input type="submit" value="Submit" />
    </form>
  </body>
</html>
HTML
};


dance;

