#!/usr/bin/perl

##############################################
### Developer: Pacheco Franco Jesús Enrique ##
### Date: May 05, 2019 #######################
### Assignment: Practice 01 ##################
### Description: nmap command parser #########
##############################################

use Data::Dumper;

@nmap_output = `nmap -sP 192.168.1.0/24`;

$report = (grep(/^Nmap done/, @nmap_output))[0];
$report =~ s/[()]//g;
@report = split / /, $report;

$hosts_scanned = @report[2];
$hosts_up = @report[5];
$hosts_down = $hosts_scanned - $hosts_up;

@ips_str = grep(/((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/, @nmap_output);
@ips = ();

foreach(@ips_str){
    chomp;
    push(@ips, (split / /, $_)[-1]);
}

$output_file = "report.txt";

open $report, '>', $output_file or die "No se pudo abrir archivo $output_file: $!";

    print $report "hosts_up:$hosts_up\n";
    print $report "hosts_down:$hosts_down\n";
    print $report "hosts_up_ips:";

    foreach(@ips){
        if($_ ne @ips[-1]) {
            print $report "$_,";
        } else {
            print $report "$_";
        }
    }

    print $report "\n";

close $report;