
use Test::More tests => 7;
my $text = "I like pie";

use_ok("PhoneUtils::Command");
my $cmd = PhoneUtils::Command->new("rev");
ok($cmd);

ok($cmd->execute("$text\n"));
is($cmd->output, reverse($text) . "\n");

my $fail = PhoneUtils::Command->new("false");
ok(! $fail->execute(""));
is($fail->status, 1);
is($fail->output, "");
