use strict;
use vars qw($VERSION %IRSSI);

$VERSION = '1.2';

%IRSSI = (
    authors     => 'Tijmen "timing" Ruizendaal & Wilmer van der Gaast',
    contact     => 'tijmen.ruizendaal@gmail.com',
    name        => 'BitlBee_tab_completion',
    description => 'Intelligent Tab-completion for Bitlbee commands.',
    license     => 'GPLv2',
    url         => 'http://the-timing.nl/stuff/irssi-bitlbee',
    changed     => '2006-10-27',
);

my $root_nick = 'root';
my $bitlbee_channel = '&bitlbee';
my $bitlbee_server_tag = 'im.bitlbee.org';
my $get_completions = 0;

my @commands;

Irssi::signal_add_last 'channel sync' => sub {
        my( $channel ) = @_;
        if( $channel->{topic} eq "Welcome to the control channel. Type \x02help\x02 for help information." ){
                $bitlbee_server_tag = $channel->{server}->{tag};
                $bitlbee_channel = $channel->{name};
        }
};

if (get_channel()) {
	$get_completions = 1;
        Irssi::server_find_tag($bitlbee_server_tag)->send_raw( 'COMPLETIONS' );
}

sub get_channel {
        my @channels = Irssi::channels();
        foreach my $channel(@channels) {
                if ($channel->{topic} eq "Welcome to the control channel. Type \x02help\x02 for help information.") {
                        $bitlbee_channel = $channel->{name};
                        $bitlbee_server_tag = $channel->{server}->{tag};
			return 1;
                }
        }
	return 0;
}

sub irc_notice {
	return unless $get_completions;
	my( $server, $msg, $from, $address, $target ) = @_;
	
	if( $msg =~ s/^COMPLETIONS // )	{
		$root_nick = $from;
		if( $msg eq 'OK' ) {
			@commands = ();
		}
		elsif( $msg eq 'END' ) {
			$get_completions = 0;
		}
		@commands = ( @commands, $msg );
		
		Irssi::signal_stop();
	}
}

sub complete_word {
	my ($complist, $window, $word, $linestart, $want_space) = @_;
	my $channel = $window->get_active_name();
	if ($channel eq $bitlbee_channel or $channel eq $root_nick or $linestart =~ /^\/(msg|query) \Q$root_nick\E */i){
		$linestart =~ s/^\/(msg|query) \Q$root_nick\E *//i;
		$linestart =~ s/^\Q$root_nick\E[:,] *//i;
		foreach my $command(@commands) {	
			if ($command =~ /^$word/i) {
				push @$complist, $command;
		    	}
		}
	}
}


Irssi::signal_add_first('complete word', 'complete_word');
Irssi::signal_add_first('message irc notice', 'irc_notice');

