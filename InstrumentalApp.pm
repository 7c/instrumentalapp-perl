package InstrumentalApp;
# https://instrumentalapp.com/docs/tcp-collector
my $version = "0.02";

use IO::Socket::INET;
use Data::Dumper;

# auto-flush on socket
$| = 1;
my $socket;


sub init() {
	$socket = new IO::Socket::INET (
	    PeerHost => 'collector.instrumentalapp.com',
	    PeerPort => '8000',
	    Proto => 'tcp',
	);
	return undef unless $socket;
	return InstrumentalApp::send("hello version perl/custom/1.0.0\n");
}

sub auth() {
	my ($token)=@_;
	InstrumentalApp::init() if (!defined($socket)) ;
	return InstrumentalApp::send("authenticate $token\n");
}

sub increment() {
	my ($key,$by)=@_;
	$by=1 if (!defined($by));
	$now=time();
	#increment test.metric 1 1502626112
	return InstrumentalApp::sendOnly("increment $key $by $now\n");	
}

sub gauge() {
	my ($key,$v)=@_;
	$v=1 if (!defined($v));
	$now=time();
	#increment test.metric 1 1502626112
	return InstrumentalApp::sendOnly("gauge $key $v $now\n");	
}


sub send() {
	my ($data)=@_;
	# data to send to a server
	#print ">$data";
	my $size = $socket->send($data);
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
	return 1;
}

sub close() {
	$socket->close();
}

1;
