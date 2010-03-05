
package PhoneUtils::Command;

sub new {
    my ($class, $cmd) = @_;
    bless { CMD => $cmd } => $class;
}

sub execute {
    my ($self, $msg, $out) = @_;
    my $pid = fork();
    die "fork: $!; aborting" unless defined $pid;
    if ($pid) { 		# parent
	wait();
	my $exit = $? >> 8;
	$self->{STATUS} = $? >> 8;
	$self->{WEXIT} = $?;
	return $self->{WEXIT} == 0;
    } else { 			# child
	open STDOUT, ">&", $out or die "couldn't dup: $!";
	exec "/bin/sh", "-c", $self->command();
	die "Couldn't exec @$self: $!\n";
    }
}

sub command { $_[0]{CMD} }

1;

