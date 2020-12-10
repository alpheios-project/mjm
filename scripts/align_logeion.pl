#!/usr/bin/perl
use strict;
use Data::Dumper;
use Unicode::UTF8 qw[decode_utf8 encode_utf8];


open (my $logeion, "<", "../../shortdefs/shortdefsGreekEnglishLogeion") or die $!;
open (my $mjm, "<", "../dat/grc-mjm-defs.dat") or die $!;

my %log;
my %mjm;

while (<$mjm>) {
  chomp;
  my ($lemma, $def, $source) = split /\|/;
  $lemma = decode_utf8( $lemma);
  $mjm{$lemma}{'def'} = decode_utf8($def);
  $mjm{$lemma}{'source'} = $source;
}

while (<$logeion>) {
  chomp;
  my ($lemma, $def) = split /\t/;
  next if $lemma eq 'lemma';
  $lemma = decode_utf8($lemma);
  $def = decode_utf8($def);
  $def =~ s/(\p{InGreekAndCoptic}.*?)([\s\W])/<span lang="grc">\1<\/span>\2/g;
  if (lcfirst($lemma) ne $lemma) {
    $log{lcfirst($lemma)} = '@';
    $log{'@' . $lemma} = $def;
  } else {
    $log{$lemma} = $def;
  }
}

my %updated;
my %added;
for my $lemma (sort keys %log) {
    if ($mjm{$lemma}) {
      if ($mjm{$lemma}{'source'} eq 'ML' && $mjm{$lemma}{'def'} ne $log{$lemma}) {
          if ($mjm{$lemma}{'def'} eq '@' && $mjm{'@' . $lemma}) {
            if ($mjm{'@' . $lemma}{'def'} ne $log{$lemma}) {
              $updated{'@' . $lemma} = $log{$lemma};
            }
          } else {
              $updated{$lemma}  = $log{$lemma};
          }
      } 
    } else {
      $added{$lemma} = $log{$lemma};
    }
}

my %new;
for my $lemma (sort keys %mjm) {
    $new{$lemma} = {};
    if ($updated{$lemma}) {
      $new{$lemma}{'def'} = $updated{$lemma};
      $new{$lemma}{'source'} = 'Logeion';
    } else {
      $new{$lemma}{'def'} = $mjm{$lemma}{'def'};
      $new{$lemma}{'source'} = $mjm{$lemma}{'source'};
    }
}
for my $lemma (sort keys %added) {
  $new{$lemma} = {};
  $new{$lemma}{'def'} = $added{$lemma};
  $new{$lemma}{'source'} = 'Logeion';
}
open (my $MJM, ">", "../dat/grc-mjm-defs.dat");
for my $lemma (sort keys %new) {
  print $MJM encode_utf8($lemma) . "|" . encode_utf8($new{$lemma}{'def'}) . "|". $new{$lemma}{'source'} . "\n";
}



