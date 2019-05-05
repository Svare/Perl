#!/usr/bin/perl

##############################################
##### Pacheco Franco Jesús Enrique ###########
##############################################

use HTTP::Tiny;
$client = HTTP::Tiny->new();
$client->timeout(1);

$input_file_openphish = "openphish.txt";
$output_file_active = "active.txt";

open $openphish, '<', $input_file_openphish or die "No se pudo abrir archivo $input_file_openphish: $!";
open $active, '>', $output_file_active or die "No se pudo abrir archivo $output_file_active: $!";

while(<$openphish>) {
    print($_);
    $_ =~ s/^\s+|\s+$//g;               # trim
    $response = $client->get($_);
    if ($response->{status} == 200) {
        print $active "$_\n";
    }
}

close $openphish;
close $active;