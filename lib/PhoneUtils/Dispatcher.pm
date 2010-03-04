
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
  return $self;
}

sub default_config_file {
  return $ENV{PHONE_DISPATCH_CONFIG} || "$ENV{HOME}/.phone-dispatch";
}

sub config_factory { "PhoneUtils::Dispatcher::Config" }

sub read_message {
  my $fh = shift;
  my $text = do { local $/; <$fh> };
  return Email::Simple->new($text);
}

sub match {
  my $self = shift;
  my $target = shift;
}

sub run_mailer {
}




1;
