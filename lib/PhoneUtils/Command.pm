
package PhoneUtils::Command;
use IPC::Open2 ();

sub new {
    my ($class, $cmd) = @_;
    bless { CMD => $cmd } => $class;
}

sub execute {
  my ($self, $input) = @_;

  my ($from, $to);
  my $pid = IPC::Open2::open2($from, $to, 
			      "/bin/sh", "-c", $self->command());

  print {$to} $input;
  close $to;

  my $output = "";
  $output .= $_ while <$from>;
  waitpid($pid, 0);
  my $status = $self->{WEXITSTATUS} = $?;
  $self->{STATUS} = ($? >> 8);
  $self->{OUTPUT} = $output;
  return $status == 0;
}

sub command { $_[0]{CMD} }
sub output { $_[0]{OUTPUT} }
sub status { $_[0]{STATUS} }

1;

