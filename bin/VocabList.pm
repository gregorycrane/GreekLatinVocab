package VocabList;

use Perseus;
use DBI;

#my %lists = ("moreland.txt" => "Moreland and Fleischer",
#	     "jenney79.txt" => "Jenney's First Year Latin (1979)",
#	     "Oxford1and2.txt" => "Oxford Latin Course Books 1 and 2",
#	     "Cambridge1and2.txt" => "Cambridge Latin Course Books 1 and 2",
#	     "wheelock.txt" => "Wheelock's Latin (5th Edition)");

my $dbh;

my @selected_lists = ();

sub new {
    my $self = {};

    $dbh = DBI->connect($Perseus::hopperDB)
	|| die "can't connect to $Perseus::hopperDB";

    bless $self;
    return $self;
}

sub set_lists_from_cookie {
    my $self = shift;
    my $lists = shift;
    
    ## make sure its just letters and numbers to prevent DB spoofing
    $lists =~ s/[^\w\:]//g;

    @selected_lists = split ":", $lists;
}

sub set_lists_from_request {
    my $self = shift;
    foreach my $list (@_) {
	$list =~ s/\W//g;
	push @selected_lists, $list;
    }
}

sub get_lists_for_cookie {
    return join ":", @selected_lists;
}

sub get_list_names {
    my $self = shift;
    my $language = shift || "la";

    my $sql = "SELECT list_id, list_nickname FROM vocab_list WHERE lang = ?";

    my $names_stmt = $dbh->prepare($sql);
    $names_stmt->execute($language);

    my %lists = ();

    my $fields;
    while ($fields = $names_stmt->fetchrow_hashref) {
	$lists{$fields->{list_id}} = $fields->{list_nickname};
    }

    return %lists;
}

sub get_list_name {
    my $self = shift;
    my $list_id = shift;

    my $sql = "SELECT list_nickname FROM vocab_list WHERE list_id = ?";

    my $name_stmt = $dbh->prepare($sql);
    $name_stmt->execute($list_id);

    my %lists = ();

    my $result;
    my $fields;
    if ($fields = $name_stmt->fetchrow_hashref) {
	$result = $fields->{list_nickname};
    }

    return $result;
}

sub get_list {
    my %vocab_list = ();

    ### if no lists are selected, return right away
    if ($#selected_lists < 0) {
	return %vocab_list;
    }

    my $sql = "SELECT DISTINCT lemma FROM vocab WHERE list_id in (\"";
    $sql .= join "\", \"", @selected_lists;
    $sql .= "\")";

    #print STDERR $sql;

    my $vocab_stmt = $dbh->prepare($sql);
    $vocab_stmt->execute;

    my $fields;
    while ($fields = $vocab_stmt->fetchrow_hashref) {
	my $word = $fields->{lemma};
	$vocab_list{$word}++;
    }

    return %vocab_list;
}

1;
