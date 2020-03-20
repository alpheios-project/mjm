#!/usr/bin/perl
use strict;
open (my $maj, "<", "../dat/grc-mjp-defs.dat") or die $!;
open (my $vg, "<", "/home/balmas/Downloads/vg.tsv") or die $!;

my %maj;
while (<$maj>) {
  chomp;
  my ($lemma, $def, $source) = split /\|/;
  $def =~ s/\n|\r//;
  $maj{$lemma} = [ $def, $source ];
}

my %vg;
while  (<$vg>) {
  chomp;
  my ($lemma, $def, $note) = split /\t/;
  if (! $maj{$lemma} ) {
    $maj{$lemma} = [ $def, 'VGorman' ];  
  }
  elsif ($maj{$lemma} && $maj{$lemma}[0] ne $def) {
    warn "$lemma|$maj{$lemma}[0]|$def\n";
  }
}
  
