package Airport::Data;

use v5.10.1;
#use open qw(:std :utf8)
#use utf8::all;

use strict;
use warnings;

use Text::CSV;
use Exporter 'import';

our @EXPORT_OK = qw( parse_airports );

sub parse_airports {
    open(my $fh, '<:encoding(utf8)', shift);
    my $csv = Text::CSV->new({ binary => 1, eol => $/ });
    my $colnames_ref = $csv->getline( $fh );

    $csv->column_names(@{$colnames_ref});
    my $airports_ref = $csv->getline_hr_all($fh);

    return $airports_ref; #array of hashes
}

1;
