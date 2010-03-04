
package PhoneUtils::Dispatcher::Config;
our $VERSION = "0.01";

sub new {
  my ($class, %args) = @_;
  my $file = delete($args{File}) or return;
  my $self = bless { File => $file } => $class;
  $self->load_config() or return;
  return $self;
}

sub load_config {
  my $self = shift;
  my $file = $self->file;

  open my($fh), "<", $file
    or die "Couldn't open '$file': $!; aborting";
}

sub file { $_[0]{File} }


1;
