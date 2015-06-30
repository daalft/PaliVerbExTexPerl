#!/usr/bin/perl

use strict;
use warnings;
use utf8;

my $file = "./A.tex";

open (my $fh, "<$file") or die $!;

my $text = "";
{
	local undef $/;
	$text = <$fh>;
}

my $listregex = "\\\\section\{List\}(.+)\\\\bibliographystyle";

my ($list) = ($text =~ /$listregex/msx);

my $entryregex = "[^%]\\\\begin\{center\}(.+?)(?=[^%]\\\\begin\{center\}|\$)";

my (@entries) = ($list =~ /$entryregex/sg);

my $lemmaregex = "\{\\\\Large.*?\\\\textbf\{(.+?)\}.*? `(.+?)'";

my $prefixregex = "\\\\paragraph\\*\{Prefix\}(.+?)\\\\end\{description\}";
my $prefixMeaningRegex = "item\\[(.+?)\\]\\s[`'](.+?)'";
my $prefixItemRegex = "\\\\item\[(.+?)\].*?(1|2|3)?\\s(sg|pl)?.*?\\\\textit\{(.+?)\}";

foreach my $entry (@entries) {
	my ($lemma, $translation) = ($entry =~ /$lemmaregex/ms);
	
	my ($prefixblock) = ($entry =~ /$prefixregex/ms);
	
	if ($prefixblock) {
		#print $prefixblock;
		my (%prefmean) = ($prefixblock =~ /\\item\[(.+?)-?]\s?['`](.+?)'/mg);
		my ($tempus, $ta, $tempspec, $person, $number, $form) = ($prefixblock =~ /\\item\[(.+?)\].*?(\\textbf\{(.+?)\})?\s(1|2|3)?\.?\s?(sg|pl)?.?\s?.*?\\textit\{(.+?)\}/);
		print "$lemma\n";
		print "$tempus $ta $tempspec $person $number $form\n";
		
		
	}
}
