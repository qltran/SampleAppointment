#!C:/Strawberry/perl/bin/perl
package Appointment;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {
		_time => shift,
		_description => shift,
	};

	bless $self, $class;
	return $self;
}

sub setTime {
	my ($self, $time) = @_;
	$self -> {_time} = $time if defined ($time);
	return $self -> {_time};
}

sub getTime {
	my( $self ) = @_;
	return $self -> {_time};
}

sub setDescription {
	my ($self, $description) = @_;
	$self -> {_description} = $description if defined ($description);
	return $self -> {_description}
}

sub getDescription {
	my( $self ) = @_;
	return $self -> {_description};
}

1;