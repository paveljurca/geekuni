package Airport::Search;

use v5.10.1;

use strict;
use warnings;
use List::Util 'min';
use Data::Types qw/:float :string/;

use Exporter 'import';

our @EXPORT_OK = qw/get_name_matching_airports get_latlong_matching_airports/; 

sub get_name_matching_airports {
    my %h = @_;
    my @matching;

    for my $air_ref (@{ $h{airports} }) {
        my $match_rex =
            $h{word} ? qr!\b$h{matching_string}\b!i
            : qr!$h{matching_string}!i;
        
        push @matching, $air_ref if $air_ref->{name} =~ $match_rex;
    }

    return \@matching;
}

#################################################
# http://mathworld.wolfram.com/GreatCircle.html #
#################################################

# !!! sorted !!!
sub get_latlong_matching_airports {
    my %h = @_;
    my ($y1, $x1) = ($h{lat}, $h{long});
    
    return [ ] unless is_float($y1)
        && is_float($x1);
    return [ ] unless abs($y1)<=90
        && abs($x1)<=180;
    return [ ] unless $h{max}<=255;
    
    my @matching = sort {
        _latlong_dist(
            [ $h{lat}, $h{long} ],
            [ $a->{latitude_deg}, $a->{longitude_deg} ]
        ) <=> _latlong_dist(
            [ $h{lat}, $h{long} ],
            [ $b->{latitude_deg}, $b->{longitude_deg} ]
        );
    } grep {
        _latlong_dist(
            [ $h{lat}, $h{long} ],
            [ $_->{latitude_deg}, $_->{longitude_deg} ]
        ) < $h{max};
    } @{ $h{airports} };

    return \@matching;
}

sub _latlong_dist {
    my ($y1, $x1) = @{ shift @_ };
    my ($y2, $x2) = @{ shift @_ };
    
    my $dist = sqrt(
            abs($y1 - $y2)**2
            + (
                min(
                    abs($x1 - $x2),
                    abs(360 - abs($x1 - $x2))
                   )
              ) ** 2
            );
            
    return $dist;
}


1;
