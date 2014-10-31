#!/usr/bin/env perl

## Aim : This file contains perl script to take multiple alignment MCMC samples (output from BayesCAT) 
## and compute pairwise posterior probability (to be used as input to FSA to summarize alignments)
## 
## Usage : perl compute.Pair.Post.Prob.pl fileNameforAlignments output.file.name
##
## Copyright (C) 2014 Heejung Shim
##
## License: GPL3+


 
my ($inputFileName, $outputFileName) = @ARGV;

$file = $inputFileName;
open(FILE1, $file);
@lines = <FILE1>;
close(FILE1);


open(FILE2, "> " . $outputFileName);

$lineIX = $#lines;

# Make a structure for summary 
# We need number of taxa and sequence length
$i = 0;
$count = 0;
$numTaxa = 0;


while($i <= $lineIX){

    @wd = split(/ /,@lines[$i]);
    if(@wd[0] eq '>alignment'){
	$count++;
    }



    if($count == 2){

	@wd = split(/ /,@lines[($i -2)]);
	$numTaxa = $#wd;
	@seqLen = ();
   
	for ($j = 0; $j < $numTaxa; $j++) {

	    $k = 1;
	    while($k <= $i){
		@wd = split(/ /,@lines[($i -$k)]);
		if(@wd[$j] >= 0){
		    push(@seqLen, @wd[$j]);
		    $k = $i + 1;
                }
		$k++;
            }
	}
	
	if($numTaxa != ($#seqLen + 1)){
	    print "ERROR! numTaxa and seqLen size should be matched\n";
	    print "numTaxa ";
	    print $numTaxa;
	    print " ";
	    print $#seqLen;
	    print "\n";
	    print @seqLen[0];
	    print " ";
	    print @seqLen[1];
	    print " ";
	    print @seqLen[2];
	    print " ";
	    print @seqLen[3];
	    print " ";
	    print "\n"	
        }
	
	$i = $lineIX +1;
    }
    $i++;


}

# Make a hash table
%Alltable = ();


# Read data and calculate pairwise posterior probs

$total = 0;
foreach $ind  (@lines[0..$lineIX]){
    
    chop($ind);
    
    @wd = split(/ /,$ind );
    if(@wd[0] ne '>alignment'){

	for ($i = 0; $i < ($numTaxa-1); $i++) {
	    for ($j = ($i+1); $j < $numTaxa; $j++) {
		if(@wd[$i] >= 0){
		    $k = @wd[$i];
                }else{
		    $k = @seqLen[$i]+1;
		}
		if(@wd[$j] >= 0){
		    $m = @wd[$j];
		}else{
		    $m = @seqLen[$j]+1;
		}
		@IXlist = ($i, $j, $k, $m);
		$IX = join("_", @IXlist);
		if(exists $Alltable{$IX}){
		    $Alltable{$IX} = $Alltable{$IX} + 1;
                }else{
		    $Alltable{$IX} = 1;
                }
            }
        }
    }else{
	$total++;
    }
}


$subtotal = $total; 
       
for ($i = 0; $i < ($numTaxa-1); $i++) {
    for ($j = ($i+1); $j < $numTaxa; $j++) {
	for ($k = 0; $k <= (@seqLen[$i]); $k++) {
	    for ($m = 0; $m <= (@seqLen[$j]); $m++) {
		@IXlist = ($i, $j, $k, $m);
		$IX = join("_", @IXlist);
		if(exists $Alltable{$IX}){
		    $value = $Alltable{$IX}/$subtotal;
		    print FILE2 "($i, $k) ~ ($j, $m) => $value\n";
                }
            }
        }

	print FILE2 "\n";
	for ($k = 0; $k <= (@seqLen[$i]); $k++) {
	    $m = @seqLen[$j] + 1;
	    @IXlist = ($i, $j, $k, $m);
	    $IX = join("_", @IXlist);
	    if(exists $Alltable{$IX}){
		$value = $Alltable{$IX}/$subtotal;
		print FILE2 "($i, $k) ~ ($j, -1) => $value\n";
	    }	    
	}

	print FILE2 "\n";
	for ($m = 0; $m <= (@seqLen[$j]); $m++) {
	    $k = @seqLen[$i] + 1;
	    @IXlist = ($i, $j, $k, $m);
	    $IX = join("_", @IXlist);
	    if(exists $Alltable{$IX}){
		$value = $Alltable{$IX}/$subtotal;
		print FILE2 "($i, -1) ~ ($j, $m) => $value\n";
	    }	    
	}
    }
}


