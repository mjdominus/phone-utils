
use Test::More tests => 4;

use_ok('PhoneUtils::Dispatcher');
my $pd = PhoneUtils::Dispatcher->new(Config => 't.dat/empty');
ok($pd);
my $data = "Subject: Foo.\n";
open my($fh), "<", \$data or die;
my $res = $pd->read_message($fh);
ok($res);
is($res->as_string, "$data\n");
