#!/usr/bin/perl

##############################################
### Developer: Pacheco Franco Jesús Enrique ##
### Date: May 05, 2019 #######################
### Assignment: Practice 02 ##################
### Description: nmap report plotter #########
##############################################

use GD::Graph::bars;
use GD::Graph::Data;
use Data::Dumper;

$input_report = "report.txt";

open $report, '<', $input_report or die "No se pudo abrir el archivo $input_report: $!";

    @report_lines = <$report>; # Obtiene un arreglo donde cada elemento es una linea del archivo.   

    $hosts_up = (split /:/, @report_lines[0])[-1];
    $hosts_down = (split /:/, @report_lines[1])[-1];

### Plot ###

    $data = GD::Graph::Data->new([
        ["hosts_up", "hosts_down"],
        [$hosts_up, $hosts_down],
    ]) or die GD::Graph::Data->error;
 
    $graph = GD::Graph::bars->new;
 
    $graph->set( 
        x_label         => 'Characteristics',
        y_label         => '# of Hosts',
        title           => 'nmap -sP net_id/mask',
        y_max_value     => $hosts_down + 10,
        dclrs           => ['green'],
        bar_spacing     => 30,
        transparent     => 0,
    ) or die $graph->error;
    
    $graph->plot($data) or die $graph->error;
    
    $file = 'report.png';
    open($out, '>', $file) or die "Cannot open '$file' for write: $!";
    binmode $out;
    print $out $graph->gd->png;
    close $out;

close $report;