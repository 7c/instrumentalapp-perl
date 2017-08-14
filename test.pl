#!/usr/bin/perl
require InstrumentalApp;
use Data::Dumper;
die("Usage: $0 <apikey>\n") if ($#ARGV<0);
print "API Key: ".$ARGV[0]."\n";
if (defined(InstrumentalApp::auth($ARGV[0]))) {
	print "Authenticated successfully\n";
	for(1..9) {
		InstrumentalApp::increment("test3.second");
		print "Incrementing key test.second $_\n";
	}
	# for(1..9) {
	# 	InstrumentalApp::gauge("test3.third",$_);
	# 	print "Gauging key test.third by $_\n";
	# }
InstrumentalApp::increment("test3.5");
$total=25;
while(1) {
	sleep(1); $total--;
	print "Sleeping $total left\n";
	if ($total<0) { last; }
}


InstrumentalApp::increment("test3.forth");

InstrumentalApp::close();
	print "Finished";
}
else {
	print "Could not authenticate\n";
}

