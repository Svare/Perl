#!/usr/bin/perl

##############################################
### Developer: Pacheco Franco Jesús Enrique ##
### Date: May 06, 2019 #######################
### Assignment: Exercise 02 Round 02 #########
### Description: lorem #######################
##############################################

@words = qw(hola como estas mi nombre es joc trabajo en el cert me gusta la buena vida y las mujeres sabrosas);

print("file name: ");
$file_name = <STDIN>;
chomp $file_name;
print("words: ");
$num = <STDIN>;
chomp $num;

open $output_file, '>', $file_name or die "No se pudo abrir archivo $file_name: $!";

foreach $i (1 .. $num) {
	$j = @words[int(rand($#words))];
	print $output_file "$j ";
}

close $output_file;