#!/usr/bin/perl
require InstrumentalApp;
use Data::Dumper;
die("Usage: $0 <apikey>\n") if ($#ARGV<0);
print "API Key: ".$ARGV[0]."\n";
if (defined(InstrumentalApp::auth($ARGV[0]))) {
	print "Authenticated successfully\n";
	for(1..9) {
		InstrumentalApp::increment("test.second");
		print "Incrementing key test.second\n";
	}
	for(1..9) {
		InstrumentalApp::gauge("test.third",$_);
		print "Gauging key test.third by $_\n";
	}

	print "Finished";
}
else {
	print "Could not authenticate\n";
}
