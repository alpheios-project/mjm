#!/usr/bin/perl
use strict;

while (<>) {
  chomp;
  my $line = $_;
  my (@words) = split /\s+/, $line;
  my $lemma = $words[0];
  my $def;
  for (my $i=1; $i < @words; $i++) {
    if ($words[$i] =~ /[a-zA-z]/i) {
      my $index = index $line, $words[$i];
      $def = substr $line, $index;
      last; 
    }
  }
  print $lemma . "|" . $def . "\n";
}


