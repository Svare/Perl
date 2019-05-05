#!/usr/bin/perl

##############################################
##### Pacheco Franco Jesús Enrique ###########
##############################################

use LWP::Simple;

@words = qw(hooks hook phisher malware Phish spam identity cybercrime spammer Trojan malicious cyber antivirus captcha fraudulent Trojan bot authentication honeypot spambot imposter bogus email internet spamming scammers hackers oddjob spoofing spammed scob worm scams hacking defacements raiu Prg viruses marlinspike Mydoom passwords referer emails password mail mails user users);

$input_file_active = "x";
open $active, '<', $input_file_active or die "No se pudo abrir archivo $input_file_active: $!";

@urls = ();

while($line = <$active>) {
    push(@urls, $line);
}

for $j (0..4) {

    $url = $urls[rand @urls];
    $url =~ s/^\s+|\s+$//g;

    $content = get $url;

    print("\n$url\n\n");

    foreach(@words) {
        if(index(lc($content), lc($_)) != -1) {
            print("\t".uc($_)."\n");
        }
    }

}

print("\n");
close $active;