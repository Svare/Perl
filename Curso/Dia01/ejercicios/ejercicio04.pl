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

foreach $key (keys %sites) {
    print "\n\t$key\n\n";
    $sites{$key} =~ tr/ /\n/;
    print($sites{$key})
}

#print(%sites); # El hash cuya llave es el dominio y el valor es una cadena de urls separadas por espacio.