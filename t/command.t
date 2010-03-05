
use Test::More tests => 4;
use Email::Simple;
my $text = "I like pie";

use_ok("PhoneUtils::Command");
my $cmd = PhoneUtils::Command->new("rev");
ok($cmd);

ok($cmd->execute("$text\n"));
is($cmd->output, reverse($text) . "\n");

