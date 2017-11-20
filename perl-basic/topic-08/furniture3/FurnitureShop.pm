package FurnitureShop;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw/hello/;

sub hello {
  my $str = shift;

  return "Hello $str! How can I help you today?";
}

sub sell {
    my ($self, $str) = @_;
    my $furniture_type = $self->description;
    
    return "Well $str, I'm absolutely certain this $furniture_type is exactly what you need!";
}

1;
