#!/usr/bin/perl


use Text::CSV_XS;
use Concord::Server 'us.test1-partners.acronis.com';
use Partners::Partner;

my $CSV_XS_CONFIG = { binary => 1, sep_char => ','};

my $csv = Text::CSV_XS->new($CSV_XS_CONFIG);

my $partner = Partners::Partner->new();

my $query = $ARGV[0]||"select p.*, l.Name as Level from Partner p, PartnerLevelItems i, PartnerTypeLevels l where i.PartnerId = p.id and l.id=i.TypeLevelId and i.TypeLevelId in (202, 203, 204)";

my $dbh = $partner->getDBC->dbh;
my $sth = $dbh->prepare($query);
unless ($sth->execute()){
	die sprintf("(%s) %s in query [%s]\n", $sth->err, $sth->errstr, $sth->{Statement});
}

my $colnames = $sth->{NAME};
$csv->combine(@{$colnames});
print $csv->string() . "\n";

while (my $rec = $sth->fetchrow_arrayref){
        $csv->combine(@{$rec});
	print $csv->string() . "\n";	
}

$sth->finish();
