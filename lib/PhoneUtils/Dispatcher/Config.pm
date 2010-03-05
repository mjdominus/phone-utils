
package PhoneUtils::Dispatcher::Config;
our $VERSION = "0.01";

sub new {
  my ($class, %args) = @_;
  my $file = delete($args{File}) or return;
  my $self = bless { File => $file, Entries => [] } => $class;
  $self->load_config() or return;
  return $self;
}

sub load_config {
  my $self = shift;
  my $file = $self->file or return;

  open my($fh), "<", $file
    or die "Couldn't open '$file': $!; aborting";

  return $self->load_config_fh($fh);
}

sub load_config_fh {
  my $self = shift;
  my $fh = shift;

  while (1) {
    my $pat = $self->_line($fh) or last;
    my $cmd = $self->_line($fh) or do {
      warn "Missing command for '$pat' at EOF";
      last;
    };
    $pat =~ s/\s*$//;
    $pat =~ s/\s+/\\s+/g;
    $pat =~ s/^/^/;
    $self->add_entry($pat, $self->command_factory->new($cmd));
  }

  return 1;
}

sub add_entry {
  my ($self, $pat, $cmd) = @_;
  push @{$self->{Entries}}, [ qr/$pat/i, $cmd ];
}

sub entries {
  return @{$_[0]{Entries}};
}

sub file { $_[0]{File} }

sub _line {
  my ($self, $fh) = @_;
  my $line;

  # Skip comments and blank lines
  do {
    $line = <$fh>;
    return unless defined $line;
  } while $line =~ /^\s*#/ || $line =~ /^\s*$/;

  return $line;
}

sub match {
  my ($self, $target) = @_;
  for my $entry ($self->entries) {
    my ($pat, $cmd) = @$entry;
    if ($target =~ $pat) {
      return $cmd;
    }
  }
  return;
}

sub command_factory {
  require PhoneUtils::Command;
  return "PhoneUtils::Command";
}

1;
