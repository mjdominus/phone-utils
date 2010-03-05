
use Test::More tests => 4;
use Email::Simple;
my $text = "I like pie";

use_ok("PhoneUtils::Command");
my $cmd = PhoneUtils::Command->new("rev");
ok($cmd);

my $msg = Email::Simple->new("");
$msg->body_set($text);

my $out = "";
open my $outfh, ">", \$out or die;

ok($cmd->execute($msg, $outfh));
is($out, reverse $text);

