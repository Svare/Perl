#!/usr/bin/perl

use Data::Dumper;
use strict;
use 5.014;

my $my_postfix_log = undef;
my $enable = undef;
my $postfix_log = undef;
my $mail_no = undef;
my $time = undef;

my $postfix_log_counter = 0;
my @users = undef;
my @log = undef;
my %mails_sent_per_user = undef;

sub get_time {

	my @date = localtime(time);

	$date[5] += 1900;
	$date[4] ++;

	map { if($_ < 10) {
		$_ = "0$_";
		}
	} @date;
	
	return "$date[5]-$date[4]-$date[3] $date[2]:$date[1]:$date[0]";

}

sub lock_user {

	my $string = 'authorized_submit_users = !';
	$string .= @_[0];
	$string .= ', static:anyone';
	
	return $string;
	
}

sub unlock_users {

	return 'authorized_submit_users = static:anyone';

}

# Lectura del archivo de configuracion

open(CONFIG_FILE, $ARGV[0]);

while(<CONFIG_FILE>) {

    chomp;

	if($_ =~ /^log/) {
		if(!defined $my_postfix_log) {
			$my_postfix_log = (split /\s*=\s*/, $_)[1];
		} else {
			$postfix_log = (split /\s*=\s*/, $_)[1];
		}
	} elsif($_ =~ /^enable/) {
		$enable = (split /\s*=\s*/, $_)[1];
	} elsif($_ =~ /^mail_no/) {
		$mail_no = (split /\s*=\s*/, $_)[1];
	} elsif($_ =~ /^time/) {
		$time = (split /\s*=\s*/, $_)[1];
	} elsif ($_ =~ /^users/) {
		@users = split /,/, (split /\s*=\s*/, $_)[1];
	}

}

close(CONFIG_FILE);

# Clean Hash

map {
	$mails_sent_per_user{$_} = 0;
} @users;

open(SERVICE_LOG, '>>', $my_postfix_log);

	open(LOG, $postfix_log);
		@log = <LOG>;
		#$postfix_log_counter = $#log;
		$postfix_log_counter = 0;
		print SERVICE_LOG "\n" . get_time() . " se inicio el servicio";
	close(LOG);

	my $times = 10;
	
	while($times ne 0) {

		my $command = unlock_users();
		my $resp = `postconf -e '$command'`;
		print SERVICE_LOG "\n" . get_time() . " se desbloquean a todos los usuarios";

		sleep(int($time)); # Duermo por cierto tiempo

		open(LOG, $postfix_log);
			
			my @log = <LOG>;

			# Se calcula en numero de correos enviados por usuario

			foreach my $i ($postfix_log_counter..$#log) {
				map {
					if(@log[$i] =~ /:\s*from=<$_/) {
						$mails_sent_per_user{$_} += 1;
					}
				} @users;
			}

			say Dumper %mails_sent_per_user;

			# Se bloquea a un usuario en caso de ser necesario

			map {

				if($mails_sent_per_user{$_} ge $mail_no) {
					my $command = lock_user($_);
					my $resp = `postconf -e '$command'`;
					print SERVICE_LOG "\n" . get_time() . " se bloquea al usuario $_";
				}

			} @users;

			
			# Clean Hash

			map {
				$mails_sent_per_user{$_} = 0;
			} @users;

			$postfix_log_counter = $#log;

		close(LOG);

		$times -= 1;

	}
	
close(SERVICE_LOG);