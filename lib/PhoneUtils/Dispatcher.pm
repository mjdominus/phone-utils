
package PhoneUtils::Dispatcher;
use PhoneUtils::Dispatcher::Config;
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


1;
