#!/usr/bin/perl

#Jesus Enrique Pacheco Franco
 
use strict;
use warnings;
use POE qw(Component::IRC);
 
my $nickname = 'PerlBot' . $$;
my $ircname  = 'Local POC';
my $server   = '127.0.0.1';
 
my @channels = ('#plenty_of_cheats');
 
# We create a new PoCo-IRC object
my $irc = POE::Component::IRC->spawn(
   nick => $nickname,
   ircname => $ircname,
   server  => $server,
) or die "Oh noooo! $!";
 
POE::Session->create(
    package_states => [
        main => [ qw(_default _start irc_001 irc_public) ],
    ],
    heap => { irc => $irc },
);
 
$poe_kernel->run();
 
sub _start {
    my $heap = $_[HEAP];
 
    # retrieve our component's object from the heap where we stashed it
    my $irc = $heap->{irc};
 
    $irc->yield( register => 'all' );
    $irc->yield( connect => { } );
    return;
}
 
sub irc_001 {
    my $sender = $_[SENDER];
 
    # Since this is an irc_* event, we can get the component's object by
    # accessing the heap of the sender. Then we register and connect to the
    # specified server.
    my $irc = $sender->get_heap();
 
    print "Connected to ", $irc->server_name(), "\n";
 
    # we join our channels
    $irc->yield( join => $_ ) for @channels;
    return;
}
 
sub irc_public {
    my ($sender, $who, $where, $what) = @_[SENDER, ARG0 .. ARG2];
    my $nick = ( split /!/, $who )[0];
    my $channel = $where->[0];
 
   # if ( my ($rot13) = $what =~ /^rot13 (.+)/ ) {
   #     $rot13 =~ tr[a-zA-Z][n-za-mN-ZA-M];
   #     $irc->yield( privmsg => $channel => "$nick: $rot13" );
   # }


    if ($what =~ /^I'm Hot/) {
	$irc->yield( privmsg => $channel => "Me too, let's have fun" );
    } elsif ($what =~ /^I feel lonley/) {
	$irc->yield( privmsg => $channel => "Come over here so that u don't feel that way <3" );
    } else {
	$irc->yield( privmsg => $channel => "Come on say something hot" );
    }

    return;
}
 
# We registered for all events, this will produce some debug info.
sub _default {
    my ($event, $args) = @_[ARG0 .. $#_];
    my @output = ( "$event: " );
 
    for my $arg (@$args) {
        if ( ref $arg eq 'ARRAY' ) {
            push( @output, '[' . join(', ', @$arg ) . ']' );
        }
        else {
            push ( @output, "'$arg'" );
        }
    }
    print join ' ', @output, "\n";
    return;
}
