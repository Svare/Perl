#!/usr/bin/perl

##############################################
### Developer: Pacheco Franco Jesús Enrique ##
### Date: May 06, 2019 #######################
### Assignment: Exercise 01 Round 03 #########
### Description: nmap report plotter #########
##############################################

use Data::Dumper;

@date = localtime(time);

$date[5] += 1900;
$date[4] ++;

print Dumper(@date);
print "\n";

map { if($_ < 10) {
    $_ = "0$_";  
}} @date;

print Dumper(@date);

print("$date[5]-$date[4]-$date[3] $date[2]:$date[1]:$date[0]\n");

