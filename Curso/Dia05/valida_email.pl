#/usr/bin/perl

use strict;
use Email::Valid;

my $address = Email::Valid->address('maurice@hevanet.com');
print($address ? 'yes' : 'no');