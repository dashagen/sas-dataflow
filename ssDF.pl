#!/usr/bin/perl -w

#####################################################
###                                               ###
### Extract data flows ( [from, to] pairs) from   ###
### SAS code                                      ###
###                                               ###
### Created by David Yeung (dyeung008@gmail.com)  ###
###                                               ###
#####################################################

$0=~/.*\/(.*)/;


# Exit if not enough arguments
die "\nUsage: $1 <SAS Script>  \n" if @ARGV!=1;


# Get SAS script content
my @contents = `cat $ARGV[0]`;
my $cont_str = join("", @contents);


# Replace Tabs with SPACEs
$cont_str=~s/\t/ /g;


# Initialize variables
my $inData      = 0;
my $toDataNm    = "";
my $fromDataNm  = "";
my $tmp         = "";
my @results     = ();



##################################################
#### Prcoess Contents                         ####
##################################################

## Match Data step
while ($cont_str=~/^\s*data\s(.+?);.*?\b(set|merge)\s(.+?);.*?\brun;/msgi) {
	
    my $to_block = rmParens($1);
    my $fr_block = rmParens($3);

    my @to_dsns = split(" ", $to_block);
    my @fr_dsns = split(" ", $fr_block);

    my $pos_str  =  pos($cont_str);

    for $toDataNm  (@to_dsns) {

        for $fromDataNm (@fr_dsns) {

            push @results,"$pos_str,$fromDataNm,$toDataNm";
        }
    }
}


## Match Proc Step
while ($cont_str=~/^\s*proc.*?data\s*=(.+?)[ (;\n](.*?)\brun;/msgi) {

	my $pos_str = pos($cont_str);

	$fromDataNm = trim($1);
	$toDataNm   = trim($2);

	if ($toDataNm=~/\bout\s*=\s*(.+?)[ ;(\n]/gi) {

		$toDataNm = trim($1);

		push @results,"$pos_str,$fromDataNm,$toDataNm";
	}
}


## Match SQl Step
while ($cont_str=~/create table (.+?) as(.+?;)/msgi) {

    my $pos_str = pos($cont_str);

    $toDataNm    =  $1;
    $fromDataNm  =  $2;

    while ($fromDataNm=~/(\bfrom\b|\bjoin\b)\s*(.+?)[\n;( ]/msgi) {

        push @results, "$pos_str,$2,$toDataNm";
    }
}




##################################################
####  Output Results                          ####
##################################################

# Store results to hash table
my %REC = ();

for (@results) {
    my ($m_pos,$from,$to) = split(",",$_);

    push @{$REC{$m_pos}}, "$from,$to";
}

my  @sorted_keys = sort {$a <=> $b } keys %REC;


# Output results
my %EXIST = ();

for (@sorted_keys) {
    my @res = @{$REC{$_}};

    my %CREATED = ();

    for (@res) {
        my ($from,$to) = split(",",$_);

        $from = lc($from);
        $to   = lc($to);

        $CREATED{$to} = 1;

        #output name of the "from" dataset
        if (not defined $EXIST{$from}) {
            $EXIST{$from} = 1;
        }

        if ($EXIST{$from} == 1) {
            print "\"$from\" -> ";
        }
        else {
            print "\"$from($EXIST{$from})\" -> ";
        }


        #output name of the "to" dataset
        if (not defined $EXIST{$to}) {
            print "\"$to\"\n";
        }
        else {
            my $new_number = $EXIST{$to} + 1;
            print "\"$to($new_number)\"\n";
        }
    }

    for (keys %CREATED) {
        if (defined $EXIST{$_} ) {
            $EXIST{$_} += 1;
        }
        else {
            $EXIST{$_} = 1;
        }
    }
}


##################################################
#### Subroutines                              ####
##################################################

# Remove trailing and leading spaces
sub trim {
    my $string = shift;

    $string =~ s/^\s+//;
    $string =~ s/\s+$//;

    return $string;
}


# Remove parentheses and contents enclosed
sub rmParens {
    my $input = shift;

    my $str_len = length($input);

    my $pcounts  = 0;
    my $firstobs = 0;

    for (my $i=0;$i<$str_len;$i++) {

        my $curr_char = substr($input ,$i, 1);

        if ($curr_char eq "(") {
            $pcounts += 1;
        }
        elsif ($curr_char eq ")") {
            $pcounts -= 1;
        }

        if ($pcounts !=0 || $curr_char eq "(" || $curr_char eq ")" ) {
            substr($input,$i,1) = " ";
        }
    }

    $input=~s/\n/ /g;

    return  $input;
}


