
package PhoneUtils::Command;

sub new {
    my ($class, $cmd) = @_;
    bless { CMD => $cmd } => $class;
}

sub execute {
    my ($self, $msg, $out) = @_;
    my ($rd, $wr);    
    pipe ($rd, $wr) or die "pipe: $!";
    my $pid = fork();
    die "fork: $!; aborting" unless defined $pid;
    if ($pid) { 		# parent
	close $rd;
	print $wr $msg->as_string();
	close $wr;
	wait();
	my $exit = $? >> 8;
	$self->{STATUS} = $? >> 8;
	$self->{WEXIT} = $?;
	return $self->{WEXIT} == 0;
    } else { 			# child
	close $wr;
	open STDIN, "<&", $rd or die "couldn't dup: $!";
	open STDOUT, ">&", $out or die "couldn't dup: $!";
	exec "/bin/sh", "-c", $self->command();
	die "Couldn't exec @$self: $!\n";
    }
}

sub command { $_[0]{CMD} }

1;

