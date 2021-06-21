#!/usr/bin/perl -w

### This script reads vocabulary lists from files and inserts them into
### the vocab, vocab_list_section, and vocab_list tables.
use lib "/web/cgi-bin";

use Perseus;
use DBI;

# connect to the hopper database
my $conn = DBI->connect($Perseus::hopperDB);

my $listfile;

## getting single list from command line
$listfile = $ARGV[0];

my %list_metadata = ();
my $list_order = 0;

my $list_id = "unset";

my $label_sth = $conn->prepare("INSERT INTO vocab_list_section VALUES (?, ?, ?)");
my $word_sth = $conn->prepare("INSERT INTO vocab VALUES (?, ?, ?, ?, null)");

open LIST, $listfile;
while (<LIST>) {
    my $line = $_;
    chomp $line;
    
    if ($line =~ /^\#/) {
	my ($field, $data) = ($line =~ /^\#(\w+)\s(.*)/);

	$list_metadata{$field} = $data;
    }
    elsif ($line =~ /^\@/) {
	## We have reached a section heading. Is this the first one?
	if ($list_id eq "unset") {
	    ## the list is uninitialized -- set it up

	    my $sql = "INSERT INTO vocab_list VALUES (?, ?, ?, ?, ?, ?)";
	    my $sth = $conn->prepare($sql);
	    $sth->execute($list_metadata{id},
			  $list_metadata{author},
			  $list_metadata{title},
			  $list_metadata{nickname},
			  $list_metadata{year},
			  $list_metadata{lang});

	    $list_id = $list_metadata{id};

	}

	$list_order++;
	my ($title) = ($line =~ /\@(.*)/);

	## now add a row for this label
	$label_sth->execute($list_id, $list_order, $title);
    }
    else {
	## data
	my ($word, $lemma) = ($line =~ /^(\w+)\s+(.+)/);

	## gloss is currently always null
	$word_sth->execute($word, $lemma, $list_id, $list_order);
    }
    

}
close LIST;
