
use Test::More tests => 5 + 27*2 + 2 + 2 * 35;

use_ok("PhoneUtils::Dispatcher::Config");

# Trivial tests with empty config table
{
  my $config =
    PhoneUtils::Dispatcher::Config->new(File => "t.dat/empty");
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
{
  my $config =
    PhoneUtils::Dispatcher::Config->new(File => "t.dat/c3");
  ok($config);
  my @e = $config->entries();
  is(@e, 5);

  my @resp = (undef, "license plates", "birthdates", "alarm",
	      "calculator", "powers");

  my %tests = (pxg => 1, PXG => 1, Xyz => 1,
	         abcd => 0,
	       19690402 => 2, "0402" => 2,
	         1 => 0, 12 => 0, 12345 => 0, 123456 => 0, 1234567 => 0,
	         123456789 => 0,
	       "at 1" => 3, "at 12" => 3, "at 3pm" => 3,
	       "at  1" => 3, "at  12" => 3, "at  3pm" => 3,
	         "at " => 0, "at12" => 0,
	       "in 13" => 3, "in 13m" => 3, "in 13h" => 3, "in   13h" => 3,
  	         "in" => 0, "in m" => 0, 
#	       "at 13h" => 0, 
	       "in13h" => 0,
	       "calc 1" => 4, "calc 1." => 4, "calc 1.1" => 4,
	       "calc   1.12" => 4, "calc 1.12a" => 4,
	         "calc" => 0, "calc " => 0, "calc .12" => 0,
	      );

 TEST:
  for my $t (keys %tests) {
    my $x = $tests{$t};
    my $command = $config->match($t);
    if ($x == 0) {  # we expect match failure here
      ok(! defined $command, "subject $t");
      warn $command->command if $t eq "at 13h";
      ok(1);
      next TEST;
    }
    my $ok = $command->execute("");
    ok($ok);
    is($command->output, "$resp[$x]\n", "subject $t");
  }
}

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

