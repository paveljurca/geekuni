package GuArt::Model;

use strict;
use warnings;
use utf8;
use List::Util qw/max min/;
use Clone 'clone';
 
 
my %dbase = (
  1=> {
    filename  => 'sd_pom.jpg',
    artist    => 'Mr. Wolf',
    real_artist    => 'Salvador Dali',
    real_title     => 'The Persistence of Memory',
    title     => "Dinner Time",
    year      => '1931',
  },
  2=> { # ?????
    filename  => 'malevich.jpg',
    real_artist    => 'Kazimir Malevich',
    artist    => 'John Malkovich',
    real_title     => "Dynamic Suprematism",
    title     => "Being Kazimir Malevich",
    year      => '1915',
  },
  3=>{
    filename  => 'scream.jpg',
    real_artist    => 'Edvard Munch',
    artist     => 'Munch',
    real_title     => 'The Scream',
    title     => 'She Ate Edvard!',
    year      => '1893',
  },
  4=> {
    filename  => 'mona.jpg',
    real_artist    => 'Leonardo da Vinci',
    artist    => 'Leonardo  DiCaprio',
    real_title     => 'Mona Lisa',
    title     => 'Juliet',
    year      => '1506',
  },
  5=> {
    filename  => 'klimt.jpg',
    artist    => 'Gustav Theodore Holst',
    real_title     => 'The Kiss',
    real_artist    => 'Gustav Klimt',
    title     => 'Collision of the Planets',
    year      => '1908',
  },
  6=>{
    filename  => 'cm.jpg',
    real_artist    => 'Claude Monet',
    artist    => 'John Lennon',
    real_title     => "The Artist's Garden at Giverny",
    title     => "Blueberry Fields",
    year      => '1900',
  },
  7=> {
    filename  => 'sunflowers.jpg',
    real_artist    => 'Vincent van Gogh',
    artist    => 'Allen Ginsberg',
    real_title     => "Sunflowers",
    title     => "Flower Power",
    year      => '1889',
  },
  8=> {
    filename  => 'miro-ns.jpg',
    artist    => 'Bíró László József',
    real_artist    => 'Miro',
    real_title     => "The Nightingale's Song at Midnight and the Morning Rain",
    title     => "Ballpoint",
    year      => '1940',
  },
  9 => {
    filename => 'warhol-marilyn.jpg',
    real_artist   => 'Andy Warhol',
    artist   => 'Homer Simpson',
    real_title => "Marilyn",
    title => "Marge",
    year  => '1962',
  }
);

$dbase{$_}->{own} = 0 foreach keys(%dbase);

=head2 get_data

Return a clone of the data - so the recipient can modify it

=cut

sub get_data {
  # clone because we don't want two different sessions modifying the same hashref
  return clone(\%dbase);
}

=head2 cant_have_any(<rh_db>, <bank_balance>)

Takes the session's database and checks to see that the user has
no artwork and cannot afford any.

=cut

sub cant_have_any {
  my ($rh_db, $bank_balance) = @_;

  my $has_none =  min( map { $rh_db->{$_}->{own} ? 0 : 1 } keys(%$rh_db) );


  my $cant_buy = min(
                  map { $rh_db->{$_}->{price} > $bank_balance ? 1 : 0 }
                    keys(%$rh_db)
                 );

  return $has_none && $cant_buy;
}

=head2 got_it_all(<rh_db>)

Takes the session's database and checks to see that the user owns
everything.

=cut

sub got_it_all {
  my $rh_db = shift;

  return min( map($rh_db->{$_}->{own} ? 1 : 0, keys(%$rh_db)) );
}

=head2 update_prices

Given a copy of \%dbase, add (or update) the price field
for each record with a random integer between 100 and 400

=cut

sub update_prices {
  my $rh_db = shift;

  foreach my $rh_artwork (values(%$rh_db)) {
    $rh_artwork->{price} = 100 + int(rand(300));
  }

}

1;
