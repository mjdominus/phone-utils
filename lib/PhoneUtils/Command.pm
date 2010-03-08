
package PhoneUtils::Command;
use IPC::Open2 ();

sub new {
    my ($class, $cmd) = @_;
    bless { CMD => $cmd } => $class;
}

sub ignoring_sigpipe (&) {
  my $code = shift;
  my $exc = ["SIGPIPE!"];
  local $SIG{PIPE} = sub { die $exc };
  my $res = eval { $code->() };
  if ($@ && ref($@) eq "ARRAY" && $@ == $exc) { return 1; }  # OK
  elsif ($@) { die; }
  else { return $res; }
}

sub execute {
  my ($self, $input) = @_;

  my $cmd = $self->command();

  my ($from, $to);
  my $pid = IPC::Open2::open2($from, $to,
			      "/bin/sh", "-c", $cmd);
  ignoring_sigpipe {
    print $to $input;
    close $to;
  };

  my $output = "";
  $output .= $_ while <$from>;
  waitpid($pid, 0) or die "wait: $!";
  my $status = $self->{WEXITSTATUS} = $?;
  $self->{STATUS} = ($? >> 8);
  $self->{OUTPUT} = $output;
  return $status == 0;
}

sub command { $_[0]{CMD} }
sub output { $_[0]{OUTPUT} }
sub status { $_[0]{STATUS} }

1;

