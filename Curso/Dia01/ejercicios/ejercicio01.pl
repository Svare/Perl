#!/usr/bin/perl

##############################################
##### Pacheco Franco Jesús Enrique ###########
##############################################

use LWP::Simple;

$output_file = "openphish.txt";

while(1) {

    $openphish_content = get 'https://openphish.com/feed.txt';

    open OPENPHISH, ">$output_file" or die "No se puede abrir $output_file";
    print OPENPHISH $openphish_content;
    close OPENPHISH;

    sleep(300);

}