
use Test::More tests => 7;

use_ok('PhoneUtils::Dispatcher');
my $pd = PhoneUtils::Dispatcher->new(Config => 't.dat/empty');
ok($pd);
ok(! $pd->debug);
my $data = "Subject: Foo.\n";
open my($fh), "<", \$data or die;
my $res = $pd->read_message($fh);
ok($res);
is($res->as_string, "$data\n");

{
  my $pd2 = PhoneUtils::Dispatcher->new(Config => 't.dat/empty',
                                        Debug => 1);
  ok($pd2);
  ok($pd2->debug);
}
