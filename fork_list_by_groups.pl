#!/usr/bin/perl

use strict;

use POSIX;
use Data::Dumper;


my %pids;

use constant STEP_LIMIT => 4;

my %dates;

my $step=1;
foreach (qw(2014-12-02 2014-12-03 2014-12-04 2014-12-05 2014-12-06 2014-12-07)){
	push @{$dates{$step}}, $_;
	if ($step == STEP_LIMIT){
		$step=1;
	}
	else {
		$step++;
	}
}

print Dumper(%dates) . "\n"; 


sub test {
	my $data = shift;
	print "test $data\n";
}

for my $step (1 .. STEP_LIMIT){
 
 	if (exists($dates{$step})){ 

	warn "STEP $step\n";

	for (0 ..$#{$dates{$step}}){
	 	my $pid = fork();
		unless ($pid){
			sleep(1);
			print "step $step $_\n";
			test($dates{$step}->[$_]);
			print "end child process...\n";
			exit;
		}
		else {
			$pids{$dates{$step}->[$_]} = $pid;
		}
	} 

	warn "pids:" . Dumper(%pids) . "\n";

	while(1){
			foreach (keys %pids){
				my $res = waitpid($pids{$_}, WNOHANG);
				if ($res){
					print "the child process $_ terminated with $res\n";
					delete $pids{$_};
				}
				else {
					#print "waiting for $_ process with pid $pids{$_}, res: $res\n";
				}
			}
			unless(%pids){
				last;
			}
	}
	}
	else {
		warn "STEP $step NOT EXISTS\n";
	}
}	

print "end parent process\n";
