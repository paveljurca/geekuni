#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes qw( time );
use 5.012;

###
# finding the max value and its key
# in an associative array
###

# https://gist.github.com/paveljurca/8ed9a9c777c31eb3d0be

sub get_max_value_key {
  my %hash_args = @_;
  my $max_value_key =
    (sort {$hash_args{$b} <=> $hash_args{$a}} keys %hash_args)[0];

  return $max_value_key;
}

sub get_max_value_key_2 {
  my %hash_args = @_;
  my($max,$key) = 0;
  for my $k (keys %hash_args) {
      my $v = $hash_args{$k};
      ($max = $v, $key = $k) if $v >= $max;
  }

  return $key;
}

use List::Util qw/reduce/;

sub get_max_value_reduce {
    my %h = @_;
    return reduce
            { $h{$a} > $h{$b} ? $a : $b } 
            keys %h;
}

#my %h = (anna => 85, bob => 96, chloe => 78, dave => 64);
#print get_max_value_reduce(%h), "\n";exit;

## STOPWATCHing ##

sub compare_subs {
    my(%hash,$start,$end,@t) = @_;

    $start = time();
    get_max_value_reduce(%hash);
    $end = time();
    push @t, $end - $start;

    $start = time();
    get_max_value_key_2(%hash);
    $end = time();
    push @t, $end - $start;

    return \@t;
}

sub build_hash {
    my %h;
    $h{$_} = int(rand(100)) for (1..shift);
    return \%h;
}

## TIME efficiency ##
# get_max_value_key
# VS
# get_max_value_key_2

my %results;
for my $size ((10,1_000,10_000,100_000)) {
    #mean
    my($_sub1,$_sub2);
    print ">> $size keys <<\n";
    for my $run (1..9) {
        my $t_ref = compare_subs(%{build_hash($size)});
        $_sub1 += $t_ref->[0];
        $_sub2 += $t_ref->[1];
        print "[ run #$run ]\n";
    }
    $_sub1 /= 9;
    $_sub2 /= 9;

    #miliseconds
    $results{$size} =
        sprintf("%27f ms%27f ms", $_sub1*1000, $_sub2*1000);
}

## OUTPUT ##
# results

printf(
      "%s%15s%30s%30s\n\n",
      "\n=== RESULTS ===\n","",
      "get_max_value_reduce",
      "get_max_value_key_2"
);
printf(
      "%15s%s\n",
      "$_ keys:",
      $results{$_}
) for (sort {$a<=>$b} keys %results);
