
package PhoneUtils::Dispatcher;
use PhoneUtils::Dispatcher::Config;
use Email::Simple;
our $VERSION = "0.01";

sub new {
  my ($class, %args) = @_;
  my $self = bless {} => $class;
  my $conf_file = delete($args{Config}) || $self->default_config_file();
  $self->{Config} = $self->config_factory->new(File => $conf_file)
    or return;
  $self->{Debug} = delete $args{Debug};
  return $self;
}

sub default_config_file {
  return $ENV{PHONE_DISPATCH_CONFIG} || "$ENV{HOME}/.phone-dispatch";
}

sub config_factory { "PhoneUtils::Dispatcher::Config" }

sub config { $_[0]{Config} }
sub debug { $_[0]{Debug} }

sub read_message {
  my ($self, $fh) = @_;
  my $text = do { local $/; <$fh> };
  return Email::Simple->new($text);
}

sub match {
  my $self = shift;
  my $target = shift;
  return $self->config->match($target);
}

sub run_mailer {
  my $self = shift;
  return \*STDOUT if $self->debug;
  open my($fh), '| /var/qmail/bin/qmail-inject mjd-cell@plover.com'
    or die "Couldn't run mailer: $!; aborting";
  return $fh;
}




1;
