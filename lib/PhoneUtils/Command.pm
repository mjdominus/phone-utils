
package PhoneUtils::Command;

sub new {
    my ($class, $cmd, @args) = @_;
    bless { CMD => $cmd, ARGS => \@args } => $class;
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
	exec $self->{CMD}, @{$self->{ARGS}}
	die "Couldn't exec @$self: $!\n";
    }
}

1;

