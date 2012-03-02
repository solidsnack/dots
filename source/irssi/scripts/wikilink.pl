#!/usr/bin/perl
use strict;
use warnings;
use Irssi;

Irssi::settings_add_str ('wikify', 'wiki_lang', 'en');
Irssi::settings_add_str ('wikify', 'wiki_active_channels', 'freenode/#wikipedia
freenode/#wikibooks');

sub wikilang {
        Irssi::settings_get_str ('wiki_lang');
}

sub urlencode {
        my $string = shift;
        $string =~ y/ /_/;
        $string =~ s/([^A-Za-z0-9_])/sprintf("%%%02X", ord($1))/seg;
        return $string;
}

sub wikilink {
        my $s = shift;
        my $u = urlencode $s;
        my $l = wikilang;
        "[[$s]] <http://$l.wikipedia.org/wiki/$u>";
}

sub wikitemplate {
        my $s = shift;
        my $u = urlencode $s;
        my $l = wikilang;
        "{{$s}} <http://$l.wikipedia.org/wiki/Template:$u>";
}

sub wikify {
        my $line = shift;
        $line =~ s/\[\[(.*?)\]\]/wikilink $1/eg;
        $line =~ s/Template:(.+?)/wikitemplate $1/eg;
        return $line;
}

sub sig_message_public {
        my ($server, $msg, $nick, $address, $target) = @_;
        my $chatnet = $server->{chatnet};
        my $ok = 0;
        for my $t (split /\s+/, Irssi::settings_get_str ('wiki_active_channels')) {
                $ok = 1 if lc $t eq lc "$chatnet/$target";
        }
        return unless $ok;
        $msg = wikify $msg;
        Irssi::signal_continue ($server, $msg, $nick, $address, $target);
}

Irssi::signal_add_first ('message public', \&sig_message_public);

