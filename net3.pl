#!/usr/bin/perl -w
use strict;
use IO::Socket::INET; 

my $host = "127.0.0.1";
my $port = 2996;

sub send_text{ #That will send a request to the server, and wait to the response
	$| = 1; # Autoflush on socket
	my $sock = IO::Socket::INET->new(PeerAddr => $host,
		PeerPort => $port,
		Proto    => 'tcp') or die "Can't create a socket: $!\n";
	my $read_line = "";
	$sock->send(pack("n", length($_[0]))); # Sends the hex version of the string length, in little endian order
	$sock->send($_[0]);
	shutdown($sock, 1); # We have stopped writing data on the socket
	$sock->recv($read_line, 100); # Receiving data with a 100 bytes maximum
	print "Text received: $read_line\n";
	$sock->close;
}

my $cadena = "\x17"; # Control character. 0x17 == 23
$cadena .= "\x05net3\x00"; # Length, name of the resource, and null byte
$cadena .= "\x0dawesomesauce\x00"; # Length, username, and null byte
$cadena .= "\x0apassword\x00"; # Length, password, and null byte

send_text($cadena);
