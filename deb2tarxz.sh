#!/usr/bin/perl -W
# $Id: deb2targz,v 1.1 2002/12/17 11:57:54 mike Exp $

# deb2targz - convert a Debian Linux .deb file to a .tar.gz
#
# This is a hack based only on my eyeball inspection of a single .deb
# file (scottfree_1.14-5_i386.deb) and not on a deep understanding of
# the format.  However, so far as I can tell, here's how it works:
#
# First line -- file header: "!<arch>" or similar
# Multiple blocks -- each one, a header line followed by data
#	Header line -- <filename> <num1> <num2> <num3> <mode> <len>
#	Data -- <len> bytes of data
# We want the block called "data.tar.gz"
#
# This naive algorithm seems to work on the other .deb files that I've
# tested it on, so I'm happy enough with it:
#	libapache-reload-perl_0.07-1_all.deb
#	libogg0_1.0.0-1_i386.deb
#	abiword_1.0.2+cvs.2002.06.05-1_i386.deb
print "This tool will convert your *.deb file then unzip it and finnaly install it in your .env\n";
print "WARNING\n";
print "Edit the script (at the end) to fix your custom env by default it's ~/.env\n";
print "WARNING\n";
use strict;
use IO::File;
#~ use File::Copy;


$0 =~ s@.*/@@;
if (@ARGV == 0) {
    print STDERR "Usage: $0 <deb-file> [<deb-file> ...]\n";
    exit(1);
}

FILE: foreach my $filename (@ARGV) {
    if ($filename !~ /\.deb$/) {
	print "$0: ignoring '$filename' (not a .deb)\n";
	next;
    }

    print "$0: converting '$filename' ...\n";
    my $fh = new IO::File("<$filename")
	or die "$0: can't read '$filename': $!";

    <$fh>;			# discard file-header line
    my $data = join('', <$fh>);
    $fh->close();

    while ($data) {
	my $header;
	($header, $data) = ($data =~ /(.*?)\n(.*)/s);
	my($name, $num1, $num2, $num3, $num4, $len) = split /\s+/, $header;
	#print "header='$header'\n\tname='$name', len=$len\n";
	if ($name eq "data.tar.xz") {
	    # Found it
	    $data = substr($data, 0, $len);
	    $filename =~ s/\.deb$/.tar.gz/;
	    my $fh = new IO::File(">$filename")
		or die "can't write '$filename': $!";
	    print $fh $data;
	    $fh->close();
	    print "$0: wrote '$filename'\n";
		system("tar", "xvf", "$filename"); 
		chdir("usr");
		my @args = ( "bash", "-c", "cp -r ./bin/* ~/.env/bin" );
		system(@args);
		my @args = ( "bash", "-c", "cp -r ./share/* ~/.env/share" );
		system(@args);
	    next FILE;
	}

	#print "$0: skipping section '$name'\n";
	if (substr($data, $len, 1) eq "\n") {
	    $len++;
	}
	$data = substr($data, $len);
    }
   	print "Maybe a data.tar.gz ? You should you deb2targz instead\n";
}

