#!/usr/bin/perl

##############################################
##### Pacheco Franco Jesús Enrique ###########
##############################################

use URI::URL;

%sites = ();
%occurrences = ();

$input_file_active = "x";
open $active, '<', $input_file_active or die "No se pudo abrir archivo $input_file_active: $!";

while($line = <$active>) {
    
    $line =~ s/^\s+|\s+$//g;
 
    $url = URI->new($line);

    if(exists($sites{$url->authority})) {
        $sites{$url->authority} .= "$url ";
        $occurrences{$url->authority} += 1;
    } else {
        $sites{$url->authority} = "$url ";
        $occurrences{$url->authority} = 1;
    }

}

foreach my $key (sort { $occurrences{$b} <=> $occurrences{$a} } keys %occurrences) {
    printf "%4d\t%s\n", $occurrences{$key}, $key;
}