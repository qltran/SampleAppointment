SampleAppointment

This application is only simple web application. We do not consider about the security problem as now.

Please follow steps below to deploy the sample appointment
	1. Install PERL interpret (e.g. Strawberry Perl 5.26.2.1)
	2. Install MySQL
	3. Create database with the script supplied in ./db_scripts/create_database_table.sql
	4. Open AppointmentServer.pl to configure the user name, password and server host to connect MySQL schema appointment_db
	   User name default is 'root' and password is '12345678'
			####### CONFIGURATION FOR DATABASE ################
			my $user = q/root/;
			my $password = q/12345678/;
			my $server = qq/dbi:mysql:appointment_db/;
			###################################################
	5. Open Command line window
	   Execute command perl AppointmentServer.pl
	6. Go to browser, try to enter localhost:8080, then enjoy funs

Thank you!