use strict;

open STATUS, "netstat -natulp 2>/dev/null |" or die "Error: $!";

while(<STATUS>) {
    next if /^udp/;
    print;
}

close STATUS or die "Error netstat: $! $?";