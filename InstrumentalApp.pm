package InstrumentalApp;
# https://instrumentalapp.com/docs/tcp-collector
my $version = "0.02";

use IO::Socket::INET;
use Data::Dumper;

# auto-flush on socket

my $socket;
my $apikey;
$| = 1;

sub connect() {
	$| = 1;
	$socket = new IO::Socket::INET (
	    PeerHost => 'collector.instrumentalapp.com',
	    PeerPort => '8000',
	    Proto => 'tcp',
	);
	return undef unless $socket;
	InstrumentalApp::send("hello version perl/custom/1.0.1\n");
	return InstrumentalApp::send("authenticate $apikey\n");
}

sub auth() {
	my ($token)=@_;
	$apikey=$token;
}

sub increment() {
	my ($key,$by)=@_;
	$by=1 if (!defined($by));
	$now=time();
	if (defined(InstrumentalApp::connect())) {
		InstrumentalApp::sendOnly("increment $key $by $now\n");
		InstrumentalApp::close();
		return 1;
	} 
	return undef;
}

sub gauge() {
	my ($key,$v)=@_;
	$v=1 if (!defined($v));
	$now=time();
	#increment test.metric 1 1502626112
	if (defined(InstrumentalApp::connect())) {
		InstrumentalApp::sendOnly("gauge $key $v $now\n");
		InstrumentalApp::close();
		return 1;
	} 
	return undef;
}


sub send() {
	my ($data)=@_;
	# data to send to a server
	#print ">$data";
	my $size = $socket->send($data);
	#$socket->flush;
	# receive a response of up to 1024 characters from server
	my $response = "";
	$socket->recv($response, 1024);
	#print "received response: $response\n";
	if ($response=~/ok/mi) { return 1; }
	return undef;
}

sub sendOnly() {
	my ($data)=@_;
	#print ">$data";
	my $size = $socket->send($data);
	#print "sent $size bytes\n";
	#$socket->flush;
	return 1;
}

sub close() {
	$socket->close();
}

1;
