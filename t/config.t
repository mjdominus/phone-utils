
use Test::More tests => 5 + 27*2 ;

use_ok("PhoneUtils::Dispatcher::Config");

# Trivial tests with empty config table
{
  my $config =
    PhoneUtils::Dispatcher::Config->new(File => "t.dat/empty-config");
  ok($config);
  my @e = $config->entries();
  is(@e, 0);
  ok(! defined  $config->match("blarf"));
  ok(! defined  $config->match("foo"));
}

# Nontrivial tests of command selection and dispatching
# These two files are the same, but the second one has comments and white space
for my $file (qw(tf tf-plus))
{
  my $config =
    PhoneUtils::Dispatcher::Config->new(File => "t.dat/$file");
  ok($config);
  my @e = $config->entries();
  is(@e, 2);
  for my $k (qw(t true True TRUE f false Falsch FALSCH)) {
    my $cmd = $config->match($k);
    ok($cmd, "search for '$k'");
  SKIP: {
      skip "Couldn't find command for '$k'", 2 unless $cmd;
      my $ok = $cmd->execute("");
      my $xok = $k =~ /t/i ? 1 : 0;
      bool_ok($ok, $xok);
      is($cmd->output, "");
    }
  }

  {
    my $cmd = $config->match("b");
    ok(! $cmd, "search for 'b'");
  }
}

# Test behavior of plausible complete config file


sub bool_ok {
  my ($a, $x, $msg) = @_;
  my $t = Test::Builder->new;
  if ($a && ! $x) {
    ok(0, "$msg: expected false, got true");
  } elsif (! $a && $x) {
    ok(0, "$msg: expected true, got false");
  } else {
    ok(1, $msg);
  }
}

