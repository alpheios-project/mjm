#!/usr/bin/perl
use Data::Dumper;

open (my $maj, "<", "../dat/majors.dat") or die $!;
open (my $lsj, "<", "../../lsj/dat/grc-lsj-defs.dat") or die $!;
open (my $nolsjresults, "<", "./nolsj.results") or die $!;

my %maj;
my %lsj;

while (<$maj>) {
  chomp;
  my ($lemma, $def) = split /\|/;
  $maj{$lemma} = $def;
}

while (<$lsj>) {
  chomp;
  my ($lemma, $def) = split /\|/;
  $lsj{$lemma} = $def;
}

my %parses;
while (<$nolsjresults>) {
  chomp;
  my @fields = split /\t/;
  my $form = $fields[0];
  my $lemma = $fields[3];
  $parses{$lemma} = $form;
}
for my $lemma (keys %maj) {
  if (! exists $lsj{$lemma} && ! exists $parses{$lemma}) {
    print "Unknown $lemma $maj{$lemma}\n"
  } else {
    #print "Found $lemma $maj{$lemma}\n"
  }
}
