#!/usr/bin/perl
use Data::Dumper;


open (my $maj, "<", "../dat/grc-mjp-defs.dat") or die $!;
open (my $ml, "<", "../../ml/dat/grc-ml-defs.dat") or die $!;

my %ml;
while (<$ml>) {
  chomp;
  my ($lemma, $def) = split /\|/;
  $def =~ s/\n|\r//;
  $ml{$lemma} = $def;
}

my %maj;
while (<$maj>) {
  chomp;
  my ($lemma, $def, $source) = split /\|/;
  if ($source ne 'LSJ') {
    $maj{$lemma} = [ $def, $source ];
  }
}

my @to_add;
for my $lemma (keys %ml) {
  my $maj_lemma = $lemma;
  $maj_lemma =~ s/\d+$//;
  $maj_lemma =~ s/^\@//;
  next if exists $maj{$lemma}; # prefer the major lemma over ml
  next if exists $maj{$maj_lemma}; # if we already have this lemma, keep it
  next if ! $ml{$lemma};
  push @to_add, [ $lemma, $ml{$lemma}, 'ML' ];
}

for my $lemma (@to_add) { 
  $maj{$lemma->[0]} = [$lemma->[1], $lemma->[2]];
}

for my $lemma (sort keys %maj) {
  print "$lemma|$maj{$lemma}[0]|$maj{$lemma}[1]\n";
}


