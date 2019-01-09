#!/usr/bin/perl
use Data::Dumper;
use strict;

# ==========================================================================================
# Word Frequency Script
# This script processes a text file to find how many times a given speaker says certain
# words. The text file is passed as an argument from the command line at the time of 
# execution. Output is a tab-delimited list containing the speaker's name, the word said, and
# the number of occurances. This file can be taken into Excel for further processing.
# ==========================================================================================


# ==========================================================================================
# CONFIGURABLE VARIABLES
# ==========================================================================================

# Skip Words
# An array of common words to ignore. To add words to this list, type them in but separate with a space.

my @skipwords = qw("a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", 
"also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", 
"are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", 
"beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", 
"de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", 
"even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", 
"formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", 
"hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", 
"interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", 
"might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", 
"next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", 
"other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", 
"seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", 
"something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", 
"there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", 
"throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", 
"via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", 
"whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", 
"yourself", "yourselves", "the");

my $min_frequency = 0;		# report only words that occur at least this many times; 0 turns this off
my $min_wordlength = 3;		# ignores words that are less than this many characters; 0 turns this off



my $inDirectory = "J:/DSM/XML Files/";
my $outDirectory = "J:/DSM/results/";

# ====================================
# Initialize some variables
# ====================================
my @filelist = @ARGV;		# pass in the filename from the command line
my $filecount = 1;
my $filelistLength = @filelist;
my %hash;


# ====================================
# PART 0: Process the Directory 
# ====================================

sub dir {
	my $current_folder = shift;
	my @all   ; 

	chdir($current_folder) or die("Cannot access folder $current_folder"); #Get the all files and folders in the given directory. 

	my @both = glob("*"); 
	my @folders; 

	foreach my $item (@both) { 
		#print "." ; # status indicator
		if(-d $item) { #Get all folders into another array - so that first the files will appear and then the folders. 
			push(@folders,$item); 
		} 
		else { #If it is a file just put it into the final array. 
			push(@all,$item); 
		}
	}
	foreach my $this_folder (@folders) { #Add the directory name to the return list - comment the next line if you don't want this feature. 
		#print "." ; # status indicator
		#push(@all,"$this_folder/"); #Continue calling this function for all the folders 
		my $full_path = "$current_folder/$this_folder"; 
		my @deep_items = dir($full_path); # :RECURSION: 
		foreach my $item (@deep_items) { 
		push(@all,"$this_folder/$item"); 
		} 
	}
	return @all;
}

print "PROCESSING DIRECTORY..." ; # status indicator

my @all = dir($inDirectory);

print "DONE\n";

@filelist = @all;

# ====================================
# PART 1: Process the Files 
# ====================================

print "PROCESSING DATA..." ; # status indicator

# build a hash of skip words. (This is faster than using an array.)
my %skipwords_hash = map { $_ => 1} @skipwords;

my %empty;

foreach my $filename (@filelist) { 

	#print "." ; # status indicator
	last if (!defined($filename)); 		# exit out of the script if we don't have a filename!
	# open the file or spit back an error
	open (FILE, "$inDirectory/$filename") || die ("Cannot open input file $filename. \n");

	# read in the whole text file at once
	$/ = undef;				# resets the line breaks so we can read everything in at once
	
	my $file = <FILE>;		# reads in the file
	$/ = "\n";				# sets the line break back to normal
	
	close FILE;

	# split the file based on the double carriage return and process each chunk separately
	# please note that the files use DOS line breaks of \r\n for each line
	
	$filename =~ /^(.*)\/(.*).xml$/sm;
	my $directory = $1;

	my $bodyFlag = 0;
	my $article = '';
	$file =~ s/"/ /g;
	
		# process each line separately so we can check for the presence of a speaker's name
	foreach my $article (split /<\/article>/, $file) {
		
		$article =~ /^.*(<article>){1}(.+)$/sm;
		$article = $2;
		
		$article =~ s/ +/ /g;	# convert all multiple spaces into single space
		$article =~ s/\n/ /g;
		
		my $hashCode = '';
		my $type = '';
		my $source = '';
		my $date = '';
		my $edition = '';
		my $alt_edition = '';
		my $title = '';
		my $byline = '';
		my $section = '';
		my $page = '';
		my $length = '';
				
		$article =~ /^(.*)<hash>(.*)<\/hash>(.*)$/sm;
		$hashCode = $2;	
	
		$article =~ /^(.*)<type>(.*)<\/type>(.*)$/sm;
		$type = $2;
		
		$article =~ /^(.*)<source>(.*)<\/source>(.*)$/sm; 
		$source = $2;
		
		$article =~ /^(.*)<date>(.*)<\/date>(.*)$/sm; 
		$date = $2;
		
		$article =~ /^(.*)<edition>(.*)<\/edition>(.*)$/sm; 
		$edition = $2;
		
		$article =~ /^(.*)<alt_edition>(.*)<\/alt_edition>(.*)$/sm; 
		$alt_edition = $2;
		
		$article =~ /^(.*)<title>(.*)<\/title>(.*)$/sm; 
		$title = $2;
		
		$article =~ /^(.*)<byline>(.*)<\/byline>(.*)$/sm; 
		$byline = $2;
		
		$article =~ /^(.*)<section>(.*)<\/section>(.*)$/sm; 
		$section = $2;
		
		$article =~ /^(.*)<page>(.*)<\/page>(.*)$/sm;
		$page = $2;
		
		$article =~ /^(.*)<length>(.*)<\/length>(.*)$/sm;
		$length = $2;
			
		if($hashCode ne '') {
                $hash{$directory}{$hashCode}{$type}{$source}{$date}{$edition}{$alt_edition}{$title}{$byline}{$section}{$page}{$length}{$filename}++;		# increment a hash for each word of this article
			}
		else {
            if($article ne '') {
                #print "%%%%%  $article ******\n";
            }
        }


	}

}

print "DONE\n";

#die Data::Dumper::Dumper(\%hash);

# ====================================
# PART 2: Generate the Report
# ====================================

print "PROCESSING OUTPUT...";

# PART 2a: Generate the Data Report
				
open OUTFILE, ">$outDirectory/output_data.txt" || die "Can't create output file: output_dataset.txt. $!\n";
foreach my $directory (keys %hash) {	
	foreach my $hashCode (keys %{$hash{$directory}}) {
	    foreach my $type(keys %{$hash{$directory}{$hashCode}}) {
		 foreach my $source(keys %{$hash{$directory}{$hashCode}{$type}}) {
		  foreach my $date(keys %{$hash{$directory}{$hashCode}{$type}{$source}}) {
		   foreach my $edition(keys %{$hash{$directory}{$hashCode}{$type}{$source}{$date}}) {
		    foreach my $alt_edition(keys %{$hash{$directory}{$hashCode}{$type}{$source}{$date}{$edition}}) {
			 foreach my $title(keys %{$hash{$directory}{$hashCode}{$type}{$source}{$date}{$edition}{$alt_edition}}) {
			  foreach my $byline(keys %{$hash{$directory}{$hashCode}{$type}{$source}{$date}{$edition}{$alt_edition}{$title}}) {
			   foreach my $section(keys %{$hash{$directory}{$hashCode}{$type}{$source}{$date}{$edition}{$alt_edition}{$title}{$byline}}) {
			    foreach my $page(keys %{$hash{$directory}{$hashCode}{$type}{$source}{$date}{$edition}{$alt_edition}{$title}{$byline}{$section}}) {
				 foreach my $length(keys %{$hash{$directory}{$hashCode}{$type}{$source}{$date}{$edition}{$alt_edition}{$title}{$byline}{$section}{$page}}) {
				  foreach my $filename(keys %{$hash{$directory}{$hashCode}{$type}{$source}{$date}{$edition}{$alt_edition}{$title}{$byline}{$section}{$page}{$length}}) {
	                print OUTFILE "$filename ~ $hashCode ~ $type ~ $source ~ $date ~ $edition ~ $alt_edition ~ $title ~ $byline ~ $section ~ $page ~ $length\n";	  
				  }}
				}}}}
			}}}}
		}			
	}
}
close OUTFILE;
