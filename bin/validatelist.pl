#!/usr/bin/perl -w

### This script reads vocabulary lists from files and determines
### whether they are valid. Rules:
###   Does it have valid metadata?
###   Does each entry have a parse?

my $listfile;

## getting single list from command line
$listfile = $ARGV[0];

my $list_id = "unset";

my $list_order = 0;

my $line_no = 0;

open LIST, $listfile;
while (<LIST>) {
    my $line = $_;
    chomp $line;
    
    $line_no++;

    if ($line =~ /^\#/) {
	if ($list_order > 0) {
	    print "metadata out of place at line $line_no\n";
	}

	my ($field, $data) = ($line =~ /^\#(\w+)\s(.*)/);

	$list_metadata{$field} = $data;
    }
    elsif ($line =~ /^\@/) {
	## We have reached a section heading. Is this the first one?
	if ($list_id eq "unset") {
            ## the list is uninitialized -- set it up

	    if (exists $list_metadata{id}) {
		print "id: $list_metadata{id}\n";
	    }
	    else {
		print "missing id\n";
	    }

	    if (exists $list_metadata{author}) {
		print "author: $list_metadata{author}\n";
	    }
	    else {
		print "missing author\n";
	    }

	    if (exists $list_metadata{title}) {
		print "title: $list_metadata{title}\n";
	    }
	    else {
		print "missing title\n";
	    }

	    if (exists $list_metadata{nickname}) {
		print "nickname: $list_metadata{nickname}\n";
	    }
	    else {
		print "missing nickname\n";
	    }

	    if (exists $list_metadata{year}) {
		print "year: $list_metadata{year}\n";
	    }
	    else {
		print "missing year\n";
	    }

	    if (exists $list_metadata{lang}) {
		print "lang: $list_metadata{lang}\n";
	    }
	    else {
		print "missing lang\n";
	    }

	    $list_id = "set";
	}
	
	$list_order++;
	my ($title) = ($line =~ /\@(.*)/);

	print "SECTION: $title\n";
    }
    else {
	## data
	if ($line !~ /^(\w+)\s+(.+)/) {
	    print "problem with $line_no: $line\n";
	}

    }
    

}
close LIST;
