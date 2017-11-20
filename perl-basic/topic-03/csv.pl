use 5.010;
use Text::CSV;

my $csv = Text::CSV->new({binary=>1,eol=>"\n",});
open(my $out, '>', q[data.csv]);

$csv->print($out, [qw{znacka model rada cena}]);
$csv->print($out, [qw{skoda fabia ambient CZK200k}]);

