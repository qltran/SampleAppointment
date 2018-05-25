use strict;
use warnings;
use File::Slurp qw/read_file/;
use CGI qw(:standard);
use JSON;
use DBI;

use MIME::Types;
use DateTime;
use Time::Piece;

{
	package AppointmentServer;
	use HTTP::Server::Simple::CGI;
	use base qw(HTTP::Server::Simple::CGI);

	my $user = q/root/;
	my $password = q/12345678/;
	my $server = qq/dbi:mysql:appointment_db/;

	my %dispatch = (
		'/search' => \&build_appointments_json,
		# ...
	);

	sub handle_request {
		my $self = shift;
		my $cgi  = shift;

		my $path    = $cgi->path_info();
		my $handler = $dispatch{$path};

		# Get rid of leading/trailing slashes on path
		my ($filename) = $path;
		$filename =~ s/^\///;
		$filename =~ s/\/$//;

		# If not filename, index this directory
		$filename = "." if ( length($filename) == 0 );

		# If path points to a directory
		$filename = $filename . "/index.html" if ( -d $filename && -e $filename . "/index.html" );

		# If this is a reference to a sub, the result is whatever the sub does
		if ( ref($handler) eq "CODE" ) {
			$handler->($cgi);
		} elsif ( -e $filename ) {
			# Serve a file, if it exists.
			my ($mt)   = MIME::Types->new();
			my ($type) = $mt->mimeTypeOf($filename);

			# Read the file
			if ( !open FILE, "<$filename" ) {
				print "HTTP/1.0 500 Error\r\n";
				print "Content-type: text/html\r\n";
				print "\r\n<h1>500 Server Error</h1><p>$filename: $!</p>\r\n";
			} else {
				# Default HTML for both init screen and after add
				binmode FILE;
				my ( $buf, $n, $data );
				my ($len) = 0;
				while ( ( $n = read FILE, $buf, 1000000 ) != 0 ) {
					$len += $n;
					$data .= $buf;
				}
				close(FILE);
				print "HTTP/1.0 200 Found\r\n";
				print "Content-type: $type\r\n";
				print "Content-length: $len\r\n";
				print "\r\n";

				# Check if this request is adding new appointment
				my $date = $cgi->param('date');
				my $time = $cgi->param('time');
				my $description = $cgi->param('description');
				if (defined $date && defined $time && defined $description) { # Add new appointment
					add_new_appointment($date, $time, $description);
					$data = insert_appointment_rows($data);
				}

				print $data;
			}
		} else {
			print "HTTP/1.0 404 Not found\r\n";
			print
				$cgi->header,
			  	$cgi->start_html('Not found'),
			  	$cgi->h1('Not found'),
			  	$cgi->end_html;
		}
	}

	# TODO ADD COMMENT
	sub insert_appointment_rows {
		my ($html) = @_;

		my $dbh = DBI->connect($server,$user,$password) or die "Can't connect to database: $DBI::errstr";
		my $sql = qq/select time, description from appointments/;
		my $sth = $dbh->prepare($sql);
		$sth->execute();

		my $rows;
		while (my $row = $sth->fetchrow_arrayref()){
			#my $time = Time::Piece->strptime($row->[0], "%Y-%m-%d %H-%M-%s");

			$rows .= qq\<tr> <td>$row->[0]</td> <td>B</td> <td>C</td> </tr>\;
		}
		my $idx = index($html, qq\</tbody>\);

		my $pre_html = substr $html, 0, $idx - 1;
		my $pos_html = substr $html, $idx - 1;

		return $pre_html . $rows . $pos_html  ;
	}

	# Connect to database then insert new appointment
	sub add_new_appointment {
		my $dbh = DBI->connect($server,$user,$password) or die "Can't connect to database: $DBI::errstr";
		my ($date, $time, $description) = @_;
		my $appointment_time = $date . ' ' . $time;
		my $sql = qq/insert into appointments(time, description) values ('$appointment_time', '$description') /;
		my $sth = $dbh->prepare($sql);
		$sth->execute();
		$dbh-> disconnect();
	}

	# Connect to database then query all appointments filtered by the criteria
	sub build_appointments_json {
		my $cgi = shift;
		return if !ref $cgi;

		my $criteria   = $cgi->param('criteria');

		# Connect SQL Server
		my $dbh = DBI->connect($server,$user,$password) or die "Can't connect to database: $DBI::errstr";

		# Query appointments
		my $sql = qq/select time, description from appointments where description like '%$criteria%'/;
		my $sth = $dbh->prepare($sql);
		$sth->execute();

		# Build JSON for response
		my $json_text = "{\"appointments\": [";
		my $appointment_exists = 0;
		while (my $row = $sth->fetchrow_arrayref()){
			$json_text .= "{\"time\":\"" . $row->[0] . "\", ";
			$json_text .= "\"description\":\"" . $row->[1] . "\"},";
			$appointment_exists = 1;
		}
		if ($appointment_exists){
			$json_text = substr $json_text, 0, -1;
		}
		$json_text .= "]}";

		$dbh-> disconnect();

		# print $cgi->header('application/json');
		print $json_text;
	}

}
my $pid = AppointmentServer->new(8080)->background();
