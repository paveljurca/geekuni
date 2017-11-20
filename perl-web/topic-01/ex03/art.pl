#!/usr/bin/perl -Ilib

use Dancer2;
use GuArt::Model;

get '/' => sub {
    my $img_ref = GuArt::Model::get_data();
    my $img_list = join "\n<br/>\n",
            map qq(<img src="images/$img_ref->{$_}->{filename}" />), keys %{ $img_ref };

    return <<HTML;
<!doctype html>
<html lang="en">
  <head>
  </head>
  <body>
    $img_list 
  </body>
</html>
HTML
};

dance;

