
# Jesus Enrique Pacheco Franco

#use strict;
use Socket;
use Data::Dumper;
use 5.014;
 
use IO::Socket::INET;

my $socket = new IO::Socket::INET (
    PeerHost => '132.247.234.6',
    PeerPort => '22191',
    Proto => 'tcp',
    ) or die "ERROR in Socket Creation : $!\n";

my $data;

$socket->recv($data, 1024); # Banner
$socket->recv($data, 1024); # Numeros

my @tmp = split(/\s+/, $data);
my $suma = @tmp[0] + @tmp[1] + @tmp[2] + @tmp[3] + @tmp[4];

$socket->send($suma);
$socket->recv($data, 1024); # Respuesta

say $data;

$socket->close();