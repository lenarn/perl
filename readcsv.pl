#!/usr/bin/perl
#
use IO::Handle;
use Text::CSV_XS;
use Data::Dumper;

my $CSV_XS_CONFIG = { binary => 1, sep_char => ",", 'quote_char'  => '"', 'escape_char' => ''};

my $filename = $ARGV[0];

open my $fh, "<:encoding(utf8)", "$filename" or die "$filename: $!";

my $csv = Text::CSV_XS->new($CSV_XS_CONFIG);

my $heads = $csv->getline( $fh ) or die "error getline:" . $csv->error_input."\n";;

print "Header:" . Dumper($heads) . "\n";

while ( my $row = $csv->getline( $fh ) ) {
	print Dumper($row) . "\n";
}

close $fh;
