# Jesus Enrique Pacheco Franco

use Data::Dumper;
use 5.014;

my $file = '/usr/share/ssh/blacklist.RSA-4096';
my $hash = "718c198b62607e211765709ad8d41e90";
my @tmp;

open(ARCHIVO, '/usr/share/ssh/blacklist.RSA-4096');

while(<ARCHIVO>){

    chomp;

    my $result = `echo -n $_ | md5sum`;
    my @tmp = split(/\s+/, $result);

    if(@tmp[0] eq $hash) {
        say "$_ :: " . @tmp[0];
        last;
    }

}

close(ARCHIVO);