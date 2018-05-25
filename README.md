#SampleAppointment<br />

This application is only simple web application. We do not consider about the security problem as now.<br />

Please follow steps below to deploy the sample appointment<br />
	1. Install PERL interpret (e.g. Strawberry Perl 5.26.2.1)<br />
	2. Install MySQL<br />
	3. Create database with the script supplied in ./db_scripts/create_database_table.sql<br />
	4. Open AppointmentServer.pl to configure the user name, password and server host to connect MySQL schema appointment_db<br />
	   User name default is 'root' and password is '12345678'<br />
			####### CONFIGURATION FOR DATABASE ################<br />
			my $user = q/root/;<br />
			my $password = q/12345678/;<br />
			my $server = qq/dbi:mysql:appointment_db/;<br />
			###################################################<br />
	5. Open Command line window<br />
	   Execute command perl AppointmentServer.pl<br />
	6. Go to browser, try to enter localhost:8080, then enjoy funs<br />

Thank you!<br />